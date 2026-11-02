-- Initial content and public asset manifest for AUTEM's public website.
-- Binary files are stored in the public site-media bucket, never in the frontend bundle.
insert into public.site_media (
  organization_id, bucket_id, storage_path, placement_key, title, alt_text, mime_type, sort_order, is_public
)
values
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/autem-hero-approved-scene-v2.png', 'image-hero', 'Escena principal AUTEM', 'Visualización arquitectónica principal de AUTEM', 'image/png', 1, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/autem-linen-atlas-background.webp', 'image-linen-background', 'Textura lino', 'Textura de fondo AUTEM', 'image/webp', 2, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/autem-proceso-territorio.png', 'image-process-territory', 'Proceso y territorio', 'Ilustración conceptual de planos y terreno', 'image/png', 3, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/autem-villa-paraiso-aerial-v2.png', 'image-villa-paraiso-aerial', 'Vista aérea Villa Paraíso', 'Vista aérea conceptual de Villa Paraíso', 'image/png', 4, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/carousel-forest-pavilion.jpg', 'image-carousel-forest-pavilion', 'Pabellón de bosque', 'Referencia de pabellón en el bosque', 'image/jpeg', 5, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/carousel-mediterranean-garden.jpg', 'image-carousel-mediterranean-garden', 'Jardín mediterráneo', 'Referencia de jardín mediterráneo', 'image/jpeg', 6, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/carousel-modern-lounge.jpg', 'image-carousel-modern-lounge', 'Sala moderna', 'Referencia de interior contemporáneo', 'image/jpeg', 7, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/carousel-stone-bedroom.jpg', 'image-carousel-stone-bedroom', 'Dormitorio en piedra', 'Referencia de dormitorio con piedra', 'image/jpeg', 8, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/carousel-sunset-terrace.jpg', 'image-carousel-sunset-terrace', 'Terraza al atardecer', 'Referencia de terraza al atardecer', 'image/jpeg', 9, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/provencal-architecture-stone.jpg', 'image-provencal-architecture', 'Arquitectura provenzal', 'Referencia de arquitectura en piedra', 'image/jpeg', 10, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/provencal-oak-detail.jpg', 'image-provencal-oak-detail', 'Detalle de roble', 'Referencia de detalle en roble', 'image/jpeg', 11, true),
  ('00000000-0000-0000-0000-000000000001', 'site-media', '00000000-0000-0000-0000-000000000001/images/territory-masterplan-nature.jpg', 'image-territory-masterplan', 'Territorio y masterplan', 'Referencia de masterplan integrado al paisaje', 'image/jpeg', 12, true)
on conflict (bucket_id, storage_path) do update set
  placement_key = excluded.placement_key,
  title = excluded.title,
  alt_text = excluded.alt_text,
  mime_type = excluded.mime_type,
  sort_order = excluded.sort_order,
  is_public = excluded.is_public;

insert into public.site_content (organization_id, section_key, content, is_published)
values
  ('00000000-0000-0000-0000-000000000001', 'home', '{"heroMedia":"image-hero","processMedia":"image-process-territory","featuredProject":"villa-paraiso"}'::jsonb, true),
  ('00000000-0000-0000-0000-000000000001', 'navigation-footer', '{"featuredProject":"villa-paraiso","contactAnchor":"#contacto"}'::jsonb, true),
  ('00000000-0000-0000-0000-000000000001', 'about', '{"heroMedia":"image-villa-paraiso-aerial"}'::jsonb, true)
on conflict (organization_id, section_key) do update set
  content = excluded.content,
  is_published = excluded.is_published;
