INSERT INTO public.organizations (id, name, slug)
VALUES ('00000000-0000-0000-0000-000000000001', 'AUTEM', 'autem')
ON CONFLICT (slug) DO UPDATE
SET name = EXCLUDED.name;

INSERT INTO public.projects (
  id,
  organization_id,
  slug,
  name,
  property_type,
  status,
  location,
  latitude,
  longitude,
  price_label,
  price_from_cop,
  area_label,
  description,
  long_description,
  features,
  cover_path,
  masterplan_path,
  masterplan_version,
  tour_url,
  published_at
)
VALUES (
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000001',
  'villa-paraiso',
  'Villa Paraíso',
  'terreno',
  'published',
  'Santa Rosa de Lima, Bolívar',
  10.495000,
  -75.367000,
  'Desde $54.000.000 COP',
  54000000,
  'Lotes campestres desde 500 m²',
  'Proyecto campestre exclusivo en Santa Rosa de Lima con 343 lotes urbanizados, vías pavimentadas y amenidades de primera categoría.',
  'Villa Paraíso es un desarrollo territorial campestre de alta valorización situado en Santa Rosa de Lima, Bolívar. Ofrece 343 parcelas urbanizadas distribuidas en manzanas planificadas, con senderos ecológicos, zonas recreativas, club house y seguridad permanente.',
  ARRAY['Vías pavimentadas', 'Red eléctrica subterránea', 'Acueducto propio', 'Zonas verdes y senderos', 'Club house campestre', 'Portería y vigilancia 24/7', 'Escrituración individual']::text[],
  '00000000-0000-0000-0000-000000000101/cover/autem-villa-paraiso-aerial-v2.png',
  '00000000-0000-0000-0000-000000000101/masterplan/masterplan-clean.svg',
  '2026.03',
  'https://my.matterport.com/show/?m=sample-autem-villa-paraiso',
  now()
)
ON CONFLICT (organization_id, slug) DO UPDATE
SET
  name = EXCLUDED.name,
  property_type = EXCLUDED.property_type,
  status = EXCLUDED.status,
  location = EXCLUDED.location,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude,
  price_label = EXCLUDED.price_label,
  price_from_cop = EXCLUDED.price_from_cop,
  area_label = EXCLUDED.area_label,
  description = EXCLUDED.description,
  long_description = EXCLUDED.long_description,
  features = EXCLUDED.features,
  cover_path = EXCLUDED.cover_path,
  masterplan_path = EXCLUDED.masterplan_path,
  masterplan_version = EXCLUDED.masterplan_version,
  tour_url = EXCLUDED.tour_url,
  published_at = coalesce(public.projects.published_at, EXCLUDED.published_at);

-- Archivos multimedia reales del proyecto
INSERT INTO public.project_media (
  project_id,
  bucket_id,
  storage_path,
  media_type,
  title,
  mime_type,
  size_bytes,
  sort_order,
  is_public
)
VALUES
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/cover/autem-villa-paraiso-aerial-v2.png',
    'cover',
    'Vista aérea principal Villa Paraíso',
    'image/png',
    3376416,
    0,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/masterplan/masterplan-clean.svg',
    'masterplan',
    'Masterplan Vectorial Interactivo',
    'image/svg+xml',
    210123,
    0,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/gallery/acceso-render.png',
    'gallery',
    'Acceso principal y portería',
    'image/png',
    1048576,
    1,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/gallery/lot-l07-entorno-verde.png',
    'gallery',
    'Entorno verde Lote 07',
    'image/png',
    1048576,
    2,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/gallery/lot-l12-quebrada.png',
    'gallery',
    'Sendero natural y quebrada Lote 12',
    'image/png',
    1048576,
    3,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/gallery/lot-l18-zona-social.png',
    'gallery',
    'Zona social y recreativa Lote 18',
    'image/png',
    1048576,
    4,
    true
  ),
  (
    '00000000-0000-0000-0000-000000000101',
    'project-media',
    '00000000-0000-0000-0000-000000000101/tour/masterplan-panorama-360.jpg',
    'tour',
    'Recorrido panorámico 360°',
    'image/jpeg',
    1029687,
    5,
    true
  )
ON CONFLICT (bucket_id, storage_path) DO NOTHING;
