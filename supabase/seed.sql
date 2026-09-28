INSERT INTO public.organizations (id, name, slug)
VALUES ('00000000-0000-0000-0000-000000000001', 'AUTEM', 'autem')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.projects (id, organization_id, slug, name, status, location, description)
VALUES (
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000001',
  'villa-paraiso',
  'Villa Paraíso',
  'draft',
  'Santa Rosa · Villanueva, Bolívar',
  'Proyecto de desarrollo territorial AUTEM.'
)
ON CONFLICT (organization_id, slug) DO NOTHING;
