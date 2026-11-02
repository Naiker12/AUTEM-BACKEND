-- Private drafts and immutable published snapshots. Existing CAD rows are left untouched.
create table if not exists public.project_navigation_versions (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  payload jsonb not null check (jsonb_typeof(payload)='object'),
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  published_by uuid references auth.users(id),
  published_at timestamptz
);

create unique index if not exists navigation_one_published_version on public.project_navigation_versions(project_id) where status='published';
alter table public.project_navigation_versions enable row level security;

drop policy if exists "members view navigation versions" on public.project_navigation_versions;
create policy "members view navigation versions" on public.project_navigation_versions for select to authenticated using (
  exists(select 1 from public.projects p join public.organization_members m on m.organization_id=p.organization_id where p.id=project_id and m.user_id=auth.uid())
);

drop policy if exists "visitors view approved navigation" on public.project_navigation_versions;
create policy "visitors view approved navigation" on public.project_navigation_versions for select to anon, authenticated using (
  status='published' and exists(select 1 from public.projects p where p.id=project_id and p.status='published')
);

drop policy if exists "managers create navigation drafts" on public.project_navigation_versions;
create policy "managers create navigation drafts" on public.project_navigation_versions for insert to authenticated with check (
  status='draft' and created_by=auth.uid() and published_by is null and published_at is null and
  exists(select 1 from public.projects p where p.id=project_id and public.can_manage_organization(p.organization_id))
);

-- No direct UPDATE/DELETE: publication is performed by the checked RPC below.
grant select on public.project_navigation_versions to anon, authenticated;
grant insert on public.project_navigation_versions to authenticated;

create or replace function public.navigation_gps_distance(ax double precision, ay double precision, bx double precision, by_ double precision)
returns double precision language sql immutable set search_path=public as $$
 select 2*6371000*asin(sqrt(least(1.0,power(sin(radians(by_-ay)/2),2)+cos(radians(ay))*cos(radians(by_))*power(sin(radians(bx-ax)/2),2))));
$$;

-- Normalize the field coordinates before solving the 3x3 least-squares systems.
create or replace function public.navigation_fit_controls(controls jsonb)
returns double precision[] language plpgsql immutable set search_path=public as $$
declare
 c jsonb; cx float8:=0; cy float8:=0; sx float8:=0; sy float8:=0;
 matrix float8[][]:=array_fill(0::float8,array[3,5]); rowv float8[];
 i integer; j integer; k integer; pivot integer; temp float8; divisor float8;
 x float8; y float8; count_ integer:=jsonb_array_length(controls);
 result_ float8[];
begin
 if count_<4 then raise exception 'At least four control points are required'; end if;
 for c in select value from jsonb_array_elements(controls) loop
  x:=(c#>>'{source,x}')::float8; y:=(c#>>'{source,y}')::float8;
  if jsonb_typeof(c#>'{source,x}') is distinct from 'number' or jsonb_typeof(c#>'{source,y}') is distinct from 'number' or jsonb_typeof(c->'accuracy') is distinct from 'number' or x is null or y is null or abs(x)>180 or abs(y)>90 or not ((c->>'accuracy')::float8 between 0 and 20) then raise exception 'Invalid GPS control'; end if;
  cx:=cx+x;cy:=cy+y;
 end loop;
 cx:=cx/count_;cy:=cy/count_;
 for c in select value from jsonb_array_elements(controls) loop
  sx:=greatest(sx,abs((c#>>'{source,x}')::float8-cx));sy:=greatest(sy,abs((c#>>'{source,y}')::float8-cy));
 end loop;
 if sx=0 or sy=0 then raise exception 'Degenerate controls';end if;
 for c in select value from jsonb_array_elements(controls) loop
  rowv:=array[((c#>>'{source,x}')::float8-cx)/sx,((c#>>'{source,y}')::float8-cy)/sy,1];
  for i in 1..3 loop
   for j in 1..3 loop matrix[i][j]:=matrix[i][j]+rowv[i]*rowv[j];end loop;
   matrix[i][4]:=matrix[i][4]+rowv[i]*(c#>>'{target,x}')::float8;
   matrix[i][5]:=matrix[i][5]+rowv[i]*(c#>>'{target,y}')::float8;
  end loop;
 end loop;
 for i in 1..3 loop
  pivot:=i;
  for j in i..3 loop if abs(matrix[j][i])>abs(matrix[pivot][i]) then pivot:=j;end if;end loop;
  if abs(matrix[pivot][i])<1e-10 then raise exception 'Collinear control points';end if;
  for k in 1..5 loop temp:=matrix[i][k];matrix[i][k]:=matrix[pivot][k];matrix[pivot][k]:=temp;end loop;
  divisor:=matrix[i][i];for k in 1..5 loop matrix[i][k]:=matrix[i][k]/divisor;end loop;
  for j in 1..3 loop
   if j<>i then divisor:=matrix[j][i];for k in 1..5 loop matrix[j][k]:=matrix[j][k]-divisor*matrix[i][k];end loop;end if;
  end loop;
 end loop;
 result_:=array[matrix[1][4]/sx,matrix[2][4]/sy,matrix[3][4]-matrix[1][4]/sx*cx-matrix[2][4]/sy*cy,matrix[1][5]/sx,matrix[2][5]/sy,matrix[3][5]-matrix[1][5]/sx*cx-matrix[2][5]/sy*cy];
 return result_;
end $$;

create or replace function public.navigation_inverse(point_ jsonb,t float8[])
returns float8[] language plpgsql immutable set search_path=public as $$
declare det float8:=t[1]*t[5]-t[2]*t[4]; x float8:=(point_->>'x')::float8-t[3]; y float8:=(point_->>'y')::float8-t[6];
begin
 if abs(det)<1e-12 then raise exception 'Noninvertible calibration';end if;
 return array[(t[5]*x-t[2]*y)/det,(t[1]*y-t[4]*x)/det];
end $$;

create or replace function public.publish_project_navigation(target_version_id uuid)
returns void language plpgsql security definer set search_path=public as $$
declare
 record_ public.project_navigation_versions; project_ public.projects;
 b jsonb; node_ jsonb; edge_ jsonb; dest_ jsonb; point_ jsonb; first_ jsonb; last_ jsonb;
 c jsonb; d jsonb; t float8[]; ga float8[]; gb float8[];
 width_ float8; height_ float8; length_ float8; area_ float8:=0; i integer; reachable boolean;
begin
 select * into record_ from public.project_navigation_versions where id=target_version_id;
 if not found then raise exception 'Version not found';end if;
 select * into project_ from public.projects where id=record_.project_id for update;
 if auth.uid() is null or not public.can_manage_organization(project_.organization_id) then raise exception 'Not authorized';end if;
 select * into record_ from public.project_navigation_versions where id=target_version_id for update;
 if record_.status<>'draft' or project_.status<>'published' then raise exception 'Only a draft of a published project can be published';end if;
 b:=record_.payload;
 if b->>'projectSlug' is distinct from project_.slug or coalesce(b->>'version','')='' or coalesce(b->>'masterplanVersion','')='' then raise exception 'Invalid project or plan version';end if;
 if project_.masterplan_version is not null and project_.masterplan_version<>b->>'masterplanVersion' then raise exception 'Plan version mismatch';end if;
 if jsonb_typeof(b->'nodes') is distinct from 'array' or jsonb_typeof(b->'edges') is distinct from 'array' or jsonb_typeof(b->'destinations') is distinct from 'array' or jsonb_typeof(b->'geofence') is distinct from 'array' or jsonb_typeof(b#>'{calibration,controls}') is distinct from 'array' or jsonb_typeof(b#>'{calibration,checkpoints}') is distinct from 'array' then raise exception 'Invalid navigation arrays';end if;
 if jsonb_array_length(b->'nodes')<2 or jsonb_array_length(b->'nodes')>5000 or jsonb_array_length(b->'edges')<1 or jsonb_array_length(b->'edges')>10000 or jsonb_array_length(b->'destinations')<1 or jsonb_array_length(b->'destinations')>5000 or jsonb_array_length(b->'geofence')<3 or jsonb_array_length(b->'geofence')>1000 or jsonb_array_length(b#>'{calibration,controls}')>100 or jsonb_array_length(b#>'{calibration,checkpoints}')<2 or jsonb_array_length(b#>'{calibration,checkpoints}')>100 then raise exception 'Incomplete navigation version';end if;
 width_:=(b#>>'{bounds,width}')::float8;height_:=(b#>>'{bounds,height}')::float8;
 if width_ is null or height_ is null or width_<=0 or height_<=0 then raise exception 'Invalid plan dimensions';end if;
 -- Check all geometry before evaluating any transform or route.
 for point_ in select value from jsonb_array_elements(b->'geofence') union all select value->'point' from jsonb_array_elements(b->'nodes') union all select p.value from jsonb_array_elements(b->'edges') e cross join lateral jsonb_array_elements(e.value->'geometry') p union all select value->'target' from jsonb_array_elements(b#>'{calibration,controls}') union all select value->'point' from jsonb_array_elements(b#>'{calibration,checkpoints}') loop
  if jsonb_typeof(point_->'x') is distinct from 'number' or jsonb_typeof(point_->'y') is distinct from 'number' or not ((point_->>'x')::float8 between 0 and width_) or not ((point_->>'y')::float8 between 0 and height_) then raise exception 'Invalid plan coordinate';end if;
 end loop;
 for i in 0..jsonb_array_length(b->'geofence')-1 loop
  first_:=b->'geofence'->i; last_:=b->'geofence'->((i+1)%jsonb_array_length(b->'geofence'));
  area_:=area_+(first_->>'x')::float8*(last_->>'y')::float8-(last_->>'x')::float8*(first_->>'y')::float8;
 end loop;
 if abs(area_)<1 then raise exception 'Degenerate geofence';end if;
 t:=public.navigation_fit_controls(b#>'{calibration,controls}');
 for c in select value from jsonb_array_elements(b#>'{calibration,controls}') loop
  for d in select value from jsonb_array_elements(b#>'{calibration,controls}') loop
   if c<>d and public.navigation_gps_distance((c#>>'{source,x}')::float8,(c#>>'{source,y}')::float8,(d#>>'{source,x}')::float8,(d#>>'{source,y}')::float8)<25 then raise exception 'Controls must be separated by 25 meters';end if;
  end loop;
 end loop;
 if (select count(distinct value->'source') from jsonb_array_elements(b#>'{calibration,controls}'))<>jsonb_array_length(b#>'{calibration,controls}') then raise exception 'Duplicate controls';end if;
 for c in select value from jsonb_array_elements(b#>'{calibration,checkpoints}') loop
  if jsonb_typeof(c#>'{gps,latitude}') is distinct from 'number' or jsonb_typeof(c#>'{gps,longitude}') is distinct from 'number' or jsonb_typeof(c->'accuracy') is distinct from 'number' or not ((c->>'accuracy')::float8 between 0 and 20) or abs((c#>>'{gps,latitude}')::float8)>90 or abs((c#>>'{gps,longitude}')::float8)>180 then raise exception 'Invalid checkpoint';end if;
  for d in select value from jsonb_array_elements(b#>'{calibration,checkpoints}') loop
   if c<>d and public.navigation_gps_distance((c#>>'{gps,longitude}')::float8,(c#>>'{gps,latitude}')::float8,(d#>>'{gps,longitude}')::float8,(d#>>'{gps,latitude}')::float8)<10 then raise exception 'Checkpoints must be separated by 10 meters';end if;
  end loop;
  for d in select value from jsonb_array_elements(b#>'{calibration,controls}') loop
   if public.navigation_gps_distance((c#>>'{gps,longitude}')::float8,(c#>>'{gps,latitude}')::float8,(d#>>'{source,x}')::float8,(d#>>'{source,y}')::float8)<10 then raise exception 'Checkpoints must be independent';end if;
  end loop;
  ga:=public.navigation_inverse(c->'point',t);
  if public.navigation_gps_distance(ga[1],ga[2],(c#>>'{gps,longitude}')::float8,(c#>>'{gps,latitude}')::float8)>10 then raise exception 'Checkpoint error exceeds 10 meters';end if;
 end loop;
 if (select count(distinct value->'gps') from jsonb_array_elements(b#>'{calibration,checkpoints}'))<>jsonb_array_length(b#>'{calibration,checkpoints}') then raise exception 'Duplicate checkpoints';end if;
 if (select count(distinct value->>'id') from jsonb_array_elements(b->'nodes'))<>jsonb_array_length(b->'nodes') or (select count(distinct value->>'id') from jsonb_array_elements(b->'edges'))<>jsonb_array_length(b->'edges') or (select count(distinct value->>'lotId') from jsonb_array_elements(b->'destinations'))<>jsonb_array_length(b->'destinations') then raise exception 'Duplicate identifiers';end if;
 for node_ in select value from jsonb_array_elements(b->'nodes') loop
  if jsonb_typeof(node_->'id') is distinct from 'string' or jsonb_typeof(node_->'label') is distinct from 'string' or coalesce(node_->>'id','')='' or left(node_->>'id',6)='__gps_' or coalesce(node_->>'label','')='' or node_->>'kind' is null or node_->>'kind' not in ('entrance','intersection','destination','amenity') then raise exception 'Invalid node';end if;
 end loop;
 if not exists(select 1 from jsonb_array_elements(b->'nodes') n where n.value->>'id'=b->>'entranceId' and n.value->>'kind'='entrance') then raise exception 'Validated entrance missing';end if;
 for edge_ in select value from jsonb_array_elements(b->'edges') loop
  select value->'point' into first_ from jsonb_array_elements(b->'nodes') where value->>'id'=edge_->>'from';
  select value->'point' into last_ from jsonb_array_elements(b->'nodes') where value->>'id'=edge_->>'to';
  if first_ is null or last_ is null or edge_->>'from'=edge_->>'to' or jsonb_typeof(edge_->'id') is distinct from 'string' or left(edge_->>'id',6)='__gps_' or coalesce(edge_->>'id','')='' or jsonb_typeof(edge_->'geometry') is distinct from 'array' or jsonb_array_length(edge_->'geometry')<2 or jsonb_array_length(edge_->'geometry')>1000 or jsonb_typeof(edge_->'modes') is distinct from 'array' or jsonb_array_length(edge_->'modes')=0 or jsonb_typeof(edge_->'isOpen') is distinct from 'boolean' or jsonb_typeof(edge_->'isBidirectional') is distinct from 'boolean' or jsonb_typeof(edge_->'lengthMeters') is distinct from 'number' or (edge_->>'lengthMeters')::float8<=0 then raise exception 'Invalid edge';end if;
  if exists(select 1 from jsonb_array_elements_text(edge_->'modes') m where m not in ('walking','driving','accessible')) then raise exception 'Invalid travel mode';end if;
  if edge_->'geometry'->0<>first_ or edge_->'geometry'->-1<>last_ then raise exception 'Edge geometry endpoints mismatch';end if;
  length_:=0;
  for i in 1..jsonb_array_length(edge_->'geometry')-1 loop
   ga:=public.navigation_inverse(edge_->'geometry'->(i-1),t);gb:=public.navigation_inverse(edge_->'geometry'->i,t);
   length_:=length_+public.navigation_gps_distance(ga[1],ga[2],gb[1],gb[2]);
  end loop;
  if length_<=0 or abs(length_-(edge_->>'lengthMeters')::float8)>greatest(2,length_*0.15) then raise exception 'Edge length inconsistent with calibration';end if;
 end loop;
 for dest_ in select value from jsonb_array_elements(b->'destinations') loop
  if not exists(select 1 from public.lots where project_id=project_.id and external_id=dest_->>'lotId') or not exists(select 1 from jsonb_array_elements(b->'nodes') n where n.value->>'id'=dest_->>'nodeId' and n.value->>'kind'='destination') then raise exception 'Destination does not belong to project';end if;
  with recursive segments as (
   select e.value->>'from' a,e.value->>'to' z from jsonb_array_elements(b->'edges') e where (e.value->>'isOpen')::boolean and e.value->'modes' ? 'walking'
   union all select e.value->>'to',e.value->>'from' from jsonb_array_elements(b->'edges') e where (e.value->>'isOpen')::boolean and (e.value->>'isBidirectional')::boolean and e.value->'modes' ? 'walking'
  ), reach(id) as (
   select b->>'entranceId' union select s.z from reach r join segments s on s.a=r.id
  ) select exists(select 1 from reach where id=dest_->>'nodeId') into reachable;
  if not reachable then raise exception 'Destination disconnected from entrance';end if;
 end loop;
 update public.project_navigation_versions set status='archived' where project_id=project_.id and status='published';
 update public.projects set masterplan_version=b->>'masterplanVersion' where id=project_.id;
 update public.project_navigation_versions set status='published',published_by=auth.uid(),published_at=now() where id=target_version_id;
end $$;

revoke all on function public.publish_project_navigation(uuid) from public;
grant execute on function public.publish_project_navigation(uuid) to authenticated;
