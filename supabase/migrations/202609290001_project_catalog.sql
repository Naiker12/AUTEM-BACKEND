-- Project catalog, media, inventory and future navigation network.
-- No seed data belongs here: projects are created through the authenticated admin panel.

create extension if not exists pgcrypto;

create or replace function public.can_manage_organization(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.organization_members membership
    where membership.organization_id = target_organization_id
      and membership.user_id = auth.uid()
      and membership.role in ('superadmin', 'administrador')
  );
$$;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  slug text not null check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  name text not null check (char_length(trim(name)) > 0),
  status text not null default 'draft' check (status in ('draft', 'published', 'archived')),
  property_type text not null default 'terreno',
  location text not null default '',
  latitude double precision,
  longitude double precision,
  price_label text,
  price_from_cop bigint check (price_from_cop is null or price_from_cop >= 0),
  area_label text,
  description text,
  long_description text,
  features jsonb not null default '[]'::jsonb check (jsonb_typeof(features) = 'array'),
  cover_path text,
  masterplan_path text,
  masterplan_version text,
  tour_url text,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (organization_id, slug)
);

create table if not exists public.project_media (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  bucket_id text not null default 'project-media',
  storage_path text not null,
  media_type text not null check (media_type in ('cover', 'gallery', 'masterplan', 'document', 'tour')), 
  title text,
  alt_text text,
  mime_type text,
  size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  sort_order integer not null default 0,
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  unique (bucket_id, storage_path)
);

create table if not exists public.lots (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  external_id text not null,
  lot_number integer,
  manzana text,
  status text not null default 'available' check (status in ('available', 'reserved', 'sold', 'last_units', 'hidden')),
  price_cop bigint check (price_cop is null or price_cop >= 0),
  area_m2 numeric(12, 2) check (area_m2 is null or area_m2 >= 0),
  centroid jsonb check (centroid is null or jsonb_typeof(centroid) = 'array'),
  geometry jsonb check (geometry is null or jsonb_typeof(geometry) = 'object'),
  metadata jsonb not null default '{}'::jsonb check (jsonb_typeof(metadata) = 'object'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (project_id, external_id)
);

create table if not exists public.project_navigation_nodes (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  external_id text not null,
  label text not null,
  kind text not null check (kind in ('entrance', 'junction', 'lot_access', 'landmark')),
  svg_point jsonb not null check (jsonb_typeof(svg_point) = 'object'),
  latitude double precision,
  longitude double precision,
  validation_status text not null default 'draft' check (validation_status in ('draft', 'validated')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (project_id, external_id)
);

create table if not exists public.project_navigation_edges (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  from_node_id uuid not null references public.project_navigation_nodes(id) on delete cascade,
  to_node_id uuid not null references public.project_navigation_nodes(id) on delete cascade,
  length_meters numeric(12, 2) not null check (length_meters > 0),
  svg_path text not null,
  modes jsonb not null default '["walking"]'::jsonb check (jsonb_typeof(modes) = 'array'),
  is_bidirectional boolean not null default true,
  is_open boolean not null default true,
  validation_status text not null default 'draft' check (validation_status in ('draft', 'validated')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (from_node_id <> to_node_id)
);

create index if not exists projects_public_lookup_idx on public.projects (slug) where status = 'published';
create index if not exists lots_project_status_idx on public.lots (project_id, status);
create unique index if not exists lots_project_number_unique on public.lots (project_id, lot_number) where lot_number is not null;
create index if not exists project_media_project_order_idx on public.project_media (project_id, media_type, sort_order);
create index if not exists navigation_nodes_project_idx on public.project_navigation_nodes (project_id);
create index if not exists navigation_edges_project_idx on public.project_navigation_edges (project_id);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at before update on public.projects
for each row execute function public.set_updated_at();

drop trigger if exists lots_set_updated_at on public.lots;
create trigger lots_set_updated_at before update on public.lots
for each row execute function public.set_updated_at();

drop trigger if exists navigation_nodes_set_updated_at on public.project_navigation_nodes;
create trigger navigation_nodes_set_updated_at before update on public.project_navigation_nodes
for each row execute function public.set_updated_at();

drop trigger if exists navigation_edges_set_updated_at on public.project_navigation_edges;
create trigger navigation_edges_set_updated_at before update on public.project_navigation_edges
for each row execute function public.set_updated_at();

alter table public.projects enable row level security;
alter table public.project_media enable row level security;
alter table public.lots enable row level security;
alter table public.project_navigation_nodes enable row level security;
alter table public.project_navigation_edges enable row level security;

create policy "published projects are public" on public.projects for select using (status = 'published');
create policy "members can view organization projects" on public.projects for select using (
  exists (select 1 from public.organization_members membership where membership.organization_id = projects.organization_id and membership.user_id = auth.uid())
);
create policy "managers can create projects" on public.projects for insert with check (public.can_manage_organization(organization_id));
create policy "managers can update projects" on public.projects for update using (public.can_manage_organization(organization_id)) with check (public.can_manage_organization(organization_id));
create policy "managers can delete projects" on public.projects for delete using (public.can_manage_organization(organization_id));

create policy "public media belongs to published project" on public.project_media for select using (
  is_public and exists (select 1 from public.projects project where project.id = project_media.project_id and project.status = 'published')
);
create policy "members can view organization media" on public.project_media for select using (
  exists (select 1 from public.projects project join public.organization_members membership on membership.organization_id = project.organization_id where project.id = project_media.project_id and membership.user_id = auth.uid())
);
create policy "managers can manage media" on public.project_media for all using (
  exists (select 1 from public.projects project where project.id = project_media.project_id and public.can_manage_organization(project.organization_id))
) with check (
  exists (select 1 from public.projects project where project.id = project_media.project_id and public.can_manage_organization(project.organization_id))
);

create policy "published lots are public" on public.lots for select using (
  exists (select 1 from public.projects project where project.id = lots.project_id and project.status = 'published' and lots.status <> 'hidden')
);
create policy "members can view organization lots" on public.lots for select using (
  exists (select 1 from public.projects project join public.organization_members membership on membership.organization_id = project.organization_id where project.id = lots.project_id and membership.user_id = auth.uid())
);
create policy "managers can manage lots" on public.lots for all using (
  exists (select 1 from public.projects project where project.id = lots.project_id and public.can_manage_organization(project.organization_id))
) with check (
  exists (select 1 from public.projects project where project.id = lots.project_id and public.can_manage_organization(project.organization_id))
);

create policy "members can view navigation" on public.project_navigation_nodes for select using (
  exists (select 1 from public.projects project join public.organization_members membership on membership.organization_id = project.organization_id where project.id = project_navigation_nodes.project_id and membership.user_id = auth.uid())
);
create policy "managers can manage navigation nodes" on public.project_navigation_nodes for all using (
  exists (select 1 from public.projects project where project.id = project_navigation_nodes.project_id and public.can_manage_organization(project.organization_id))
) with check (
  exists (select 1 from public.projects project where project.id = project_navigation_nodes.project_id and public.can_manage_organization(project.organization_id))
);
create policy "members can view navigation edges" on public.project_navigation_edges for select using (
  exists (select 1 from public.projects project join public.organization_members membership on membership.organization_id = project.organization_id where project.id = project_navigation_edges.project_id and membership.user_id = auth.uid())
);
create policy "managers can manage navigation edges" on public.project_navigation_edges for all using (
  exists (select 1 from public.projects project where project.id = project_navigation_edges.project_id and public.can_manage_organization(project.organization_id))
) with check (
  exists (select 1 from public.projects project where project.id = project_navigation_edges.project_id and public.can_manage_organization(project.organization_id))
);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('project-media', 'project-media', true, 26214400, array['image/jpeg', 'image/png', 'image/webp', 'image/avif', 'image/svg+xml', 'application/pdf'])
on conflict (id) do update set public = excluded.public, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

create policy "project managers upload project media" on storage.objects for insert to authenticated with check (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);
create policy "project managers update project media" on storage.objects for update to authenticated using (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);
create policy "project managers delete project media" on storage.objects for delete to authenticated using (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);
