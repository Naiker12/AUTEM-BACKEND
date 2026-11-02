-- Global website content. Project resources remain in project-media/project_media.
create table if not exists public.site_content (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  section_key text not null check (section_key ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  content jsonb not null default '{}'::jsonb check (jsonb_typeof(content) = 'object'),
  is_published boolean not null default true,
  updated_at timestamptz not null default now(),
  unique (organization_id, section_key)
);

create table if not exists public.site_media (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  bucket_id text not null default 'site-media',
  storage_path text not null,
  placement_key text not null check (placement_key ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  title text,
  alt_text text,
  mime_type text,
  size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  sort_order integer not null default 0,
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  unique (bucket_id, storage_path),
  unique (organization_id, placement_key, sort_order)
);

create index if not exists site_content_public_lookup_idx on public.site_content (organization_id, section_key) where is_published;
create index if not exists site_media_placement_idx on public.site_media (organization_id, placement_key, sort_order);

create trigger site_content_set_updated_at before update on public.site_content
for each row execute function public.set_updated_at();

alter table public.site_content enable row level security;
alter table public.site_media enable row level security;

create policy "public can view published site content" on public.site_content for select using (is_published);
create policy "members can view organization site content" on public.site_content for select using (
  exists (select 1 from public.organization_members membership where membership.organization_id = site_content.organization_id and membership.user_id = auth.uid())
);
create policy "managers can manage site content" on public.site_content for all using (public.can_manage_organization(organization_id)) with check (public.can_manage_organization(organization_id));

create policy "public can view public site media metadata" on public.site_media for select using (is_public);
create policy "members can view organization site media" on public.site_media for select using (
  exists (select 1 from public.organization_members membership where membership.organization_id = site_media.organization_id and membership.user_id = auth.uid())
);
create policy "managers can manage site media" on public.site_media for all using (public.can_manage_organization(organization_id)) with check (public.can_manage_organization(organization_id));

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('site-media', 'site-media', true, 26214400, array['image/jpeg', 'image/png', 'image/webp', 'image/avif', 'image/svg+xml', 'application/pdf'])
on conflict (id) do update set public = excluded.public, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

create policy "site managers upload site media" on storage.objects for insert to authenticated with check (
  bucket_id = 'site-media' and exists (select 1 from public.organizations organization where organization.id::text = (storage.foldername(storage.objects.name))[1] and public.can_manage_organization(organization.id))
);
create policy "site managers update site media" on storage.objects for update to authenticated using (
  bucket_id = 'site-media' and exists (select 1 from public.organizations organization where organization.id::text = (storage.foldername(storage.objects.name))[1] and public.can_manage_organization(organization.id))
);
create policy "site managers delete site media" on storage.objects for delete to authenticated using (
  bucket_id = 'site-media' and exists (select 1 from public.organizations organization where organization.id::text = (storage.foldername(storage.objects.name))[1] and public.can_manage_organization(organization.id))
);
create policy "public can view site media objects" on storage.objects for select to public using (bucket_id = 'site-media');
