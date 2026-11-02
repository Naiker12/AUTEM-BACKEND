-- Security hardening migration:
-- 1. Revokes direct SELECT privilege on organization_members from anonymous visitors (anon).
-- 2. Introduces a SECURITY DEFINER helper function is_organization_member() with fixed search_path.
-- 3. Restricts member/manager RLS policies explicitly to the 'authenticated' role.

create or replace function public.is_organization_member(target_organization_id uuid)
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
  );
$$;

revoke all on function public.is_organization_member(uuid) from public;
grant execute on function public.is_organization_member(uuid) to authenticated;

revoke select on public.organization_members from anon;

-- Projects policies
drop policy if exists "members can view organization projects" on public.projects;
create policy "members can view organization projects"
  on public.projects
  for select
  to authenticated
  using (public.is_organization_member(organization_id));

drop policy if exists "managers can create projects" on public.projects;
create policy "managers can create projects"
  on public.projects
  for insert
  to authenticated
  with check (public.can_manage_organization(organization_id));

drop policy if exists "managers can update projects" on public.projects;
create policy "managers can update projects"
  on public.projects
  for update
  to authenticated
  using (public.can_manage_organization(organization_id))
  with check (public.can_manage_organization(organization_id));

drop policy if exists "managers can delete projects" on public.projects;
create policy "managers can delete projects"
  on public.projects
  for delete
  to authenticated
  using (public.can_manage_organization(organization_id));

-- Project media policies
drop policy if exists "members can view organization media" on public.project_media;
create policy "members can view organization media"
  on public.project_media
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_media.project_id
        and public.is_organization_member(project.organization_id)
    )
  );

drop policy if exists "managers can manage media" on public.project_media;
create policy "managers can manage media"
  on public.project_media
  for all
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_media.project_id
        and public.can_manage_organization(project.organization_id)
    )
  )
  with check (
    exists (
      select 1
      from public.projects project
      where project.id = project_media.project_id
        and public.can_manage_organization(project.organization_id)
    )
  );

-- Lots policies
drop policy if exists "members can view organization lots" on public.lots;
create policy "members can view organization lots"
  on public.lots
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = lots.project_id
        and public.is_organization_member(project.organization_id)
    )
  );

drop policy if exists "managers can manage lots" on public.lots;
create policy "managers can manage lots"
  on public.lots
  for all
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = lots.project_id
        and public.can_manage_organization(project.organization_id)
    )
  )
  with check (
    exists (
      select 1
      from public.projects project
      where project.id = lots.project_id
        and public.can_manage_organization(project.organization_id)
    )
  );

-- Navigation nodes & edges policies
drop policy if exists "members can view navigation" on public.project_navigation_nodes;
create policy "members can view navigation"
  on public.project_navigation_nodes
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_nodes.project_id
        and public.is_organization_member(project.organization_id)
    )
  );

drop policy if exists "managers can manage navigation nodes" on public.project_navigation_nodes;
create policy "managers can manage navigation nodes"
  on public.project_navigation_nodes
  for all
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_nodes.project_id
        and public.can_manage_organization(project.organization_id)
    )
  )
  with check (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_nodes.project_id
        and public.can_manage_organization(project.organization_id)
    )
  );

drop policy if exists "members can view navigation edges" on public.project_navigation_edges;
create policy "members can view navigation edges"
  on public.project_navigation_edges
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_edges.project_id
        and public.is_organization_member(project.organization_id)
    )
  );

drop policy if exists "managers can manage navigation edges" on public.project_navigation_edges;
create policy "managers can manage navigation edges"
  on public.project_navigation_edges
  for all
  to authenticated
  using (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_edges.project_id
        and public.can_manage_organization(project.organization_id)
    )
  )
  with check (
    exists (
      select 1
      from public.projects project
      where project.id = project_navigation_edges.project_id
        and public.can_manage_organization(project.organization_id)
    )
  );

-- Site content & media policies
drop policy if exists "members can view organization site content" on public.site_content;
create policy "members can view organization site content"
  on public.site_content
  for select
  to authenticated
  using (public.is_organization_member(organization_id));

drop policy if exists "managers can manage site content" on public.site_content;
create policy "managers can manage site content"
  on public.site_content
  for all
  to authenticated
  using (public.can_manage_organization(organization_id))
  with check (public.can_manage_organization(organization_id));

drop policy if exists "members can view organization site media" on public.site_media;
create policy "members can view organization site media"
  on public.site_media
  for select
  to authenticated
  using (public.is_organization_member(organization_id));

drop policy if exists "managers can manage site media" on public.site_media;
create policy "managers can manage site media"
  on public.site_media
  for all
  to authenticated
  using (public.can_manage_organization(organization_id))
  with check (public.can_manage_organization(organization_id));

