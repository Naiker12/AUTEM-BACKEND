-- 202610310004_update_villa_paraiso_info.sql
-- Actualiza los datos oficiales de Villa Paraíso

UPDATE public.projects
SET
  name = 'Villa Paraíso',
  location = 'Santa Rosa de Lima a 1 kilometro vía a Villanueva',
  area_label = '25,45 hectáreas',
  description = 'Villa Paraíso: 340 lotes para casas campestres o de segunda vivienda en 25,45 hectáreas en Santa Rosa de Lima.',
  long_description = 'Villa Paraíso reúne 340 lotes campestres distribuidos en 25,45 hectáreas en Santa Rosa de Lima a 1 kilometro vía a Villanueva. Ofrece lotes para casas campestres o de segunda vivienda con la posibilidad de que también nuestra empresa le diseñe y construya su Vivienda.',
  features = jsonb_build_array(
    '340 lotes campestres',
    'Área total del proyecto: 25,45 hectáreas',
    'Lotes para casas campestres o segunda vivienda',
    'Opción de diseño y construcción personalizada',
    'Vías internas pavimentadas',
    'Corredores naturales y arroyo protegido',
    'Zona social y amenidades',
    'Redes y servicios planificados',
    'Acceso y portería a 1 km vía a Villanueva'
  ),
  updated_at = now()
WHERE slug IN ('villa-paraiso', 'lotes-360')
   OR name ILIKE '%Villa Para%';

