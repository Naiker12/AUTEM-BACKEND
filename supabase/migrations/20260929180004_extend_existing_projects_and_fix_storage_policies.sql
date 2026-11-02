-- Compatibility migration for a pre-existing public.projects table.
-- Adds catalog fields and fixes storage.objects RLS policies.

alter table public.projects
  add column if not exists property_type text not null default 'terreno',
  add column if not exists latitude double precision,
  add column if not exists longitude double precision,
  add column if not exists price_label text,
  add column if not exists price_from_cop bigint,
  add column if not exists area_label text,
  add column if not exists long_description text,
  add column if not exists features jsonb not null default '[]'::jsonb,
  add column if not exists cover_path text,
  add column if not exists masterplan_path text,
  add column if not exists masterplan_version text,
  add column if not exists tour_url text,
  add column if not exists published_at timestamptz;

alter table public.projects
  alter column location set default '',
  alter column description set default '';

alter table public.projects
  drop constraint if exists projects_price_from_cop_check,
  add constraint projects_price_from_cop_check check (price_from_cop is null or price_from_cop >= 0),
  drop constraint if exists projects_features_array_check,
  add constraint projects_features_array_check check (jsonb_typeof(features) = 'array');

create unique index if not exists projects_organization_slug_unique
  on public.projects (organization_id, slug);

create index if not exists projects_public_lookup_idx
  on public.projects (slug)
  where status = 'published';

-- Drop and recreate storage policies with correct column qualification on storage.objects.name
drop policy if exists "project managers upload project media" on storage.objects;
create policy "project managers upload project media" on storage.objects for insert to authenticated with check (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(storage.objects.name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);

drop policy if exists "project managers update project media" on storage.objects;
create policy "project managers update project media" on storage.objects for update to authenticated using (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(storage.objects.name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);

drop policy if exists "project managers delete project media" on storage.objects;
create policy "project managers delete project media" on storage.objects for delete to authenticated using (
  bucket_id = 'project-media'
  and exists (
    select 1 from public.projects project
    where project.id::text = (storage.foldername(storage.objects.name))[1]
      and public.can_manage_organization(project.organization_id)
  )
);

drop policy if exists "public can view project media objects" on storage.objects;
create policy "public can view project media objects" on storage.objects for select to public using (
  bucket_id = 'project-media'
);

