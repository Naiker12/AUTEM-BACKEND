-- Migration: Storage Buckets, CAD formats, and Public Documents RPC
-- 1. Configure project-media, project-cad, and project-360 storage buckets.
-- 2. Expand project_media.media_type with cad_source, masterplan_vector, and georef.
-- 3. Set up storage.objects RLS policies enforcing extension verification for CAD files.
-- 4. Create public RPC get_project_documents(p_project_slug).

-- 1. STORAGE BUCKETS CONFIGURATION
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'project-media',
  'project-media',
  true,
  52428800, -- 50 MB
  ARRAY[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/avif',
    'image/svg+xml',
    'application/pdf',
    'video/mp4'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'project-cad',
  'project-cad',
  false, -- Private bucket
  104857600, -- 100 MB
  ARRAY[
    'application/octet-stream',
    'application/json',
    'application/geo+json',
    'image/vnd.dxf',
    'application/dxf',
    'image/x-dwg',
    'application/dwg'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'project-360',
  'project-360',
  true,
  104857600, -- 100 MB
  ARRAY[
    'image/jpeg',
    'image/webp',
    'video/mp4'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;


-- 2. EXPAND project_media.media_type ENUM CHECK
ALTER TABLE public.project_media
  DROP CONSTRAINT IF EXISTS project_media_media_type_check;

ALTER TABLE public.project_media
  ADD CONSTRAINT project_media_media_type_check
  CHECK (media_type IN (
    'cover',
    'gallery',
    'masterplan',
    'document',
    'tour',
    'cad_source',
    'masterplan_vector',
    'georef'
  ));


-- 3. STORAGE POLICIES WITH SERVER-SIDE CAD VALIDATION
-- Project-CAD Policies (Private)
DROP POLICY IF EXISTS "managers upload cad files" ON storage.objects;
CREATE POLICY "managers upload cad files"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'project-cad'
    AND lower(storage.extension(name)) IN ('dxf', 'dwg', 'geojson', 'json')
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND public.can_manage_organization(p.organization_id)
    )
  );

DROP POLICY IF EXISTS "managers update cad files" ON storage.objects;
CREATE POLICY "managers update cad files"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'project-cad'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND public.can_manage_organization(p.organization_id)
    )
  );

DROP POLICY IF EXISTS "managers delete cad files" ON storage.objects;
CREATE POLICY "managers delete cad files"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'project-cad'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND public.can_manage_organization(p.organization_id)
    )
  );

DROP POLICY IF EXISTS "authorized members view cad files" ON storage.objects;
CREATE POLICY "authorized members view cad files"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'project-cad'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      JOIN public.organization_members om ON om.organization_id = p.organization_id
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND om.user_id = auth.uid()
    )
  );

-- Project-360 Policies
DROP POLICY IF EXISTS "public view 360 media" ON storage.objects;
CREATE POLICY "public view 360 media"
  ON storage.objects
  FOR SELECT
  TO public
  USING (
    bucket_id = 'project-360'
  );

DROP POLICY IF EXISTS "managers manage 360 media" ON storage.objects;
CREATE POLICY "managers manage 360 media"
  ON storage.objects
  FOR ALL
  TO authenticated
  USING (
    bucket_id = 'project-360'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND public.can_manage_organization(p.organization_id)
    )
  )
  WITH CHECK (
    bucket_id = 'project-360'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id::text = (storage.foldername(storage.objects.name))[1]
        AND public.can_manage_organization(p.organization_id)
    )
  );


-- 4. RPC: get_project_documents
DROP FUNCTION IF EXISTS public.get_project_documents(text);
DROP FUNCTION IF EXISTS public.get_project_documents;
CREATE OR REPLACE FUNCTION public.get_project_documents(p_project_slug text)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_project_id uuid;
  v_status text;
  v_result jsonb;
BEGIN
  SELECT id, status::text INTO v_project_id, v_status
  FROM public.projects
  WHERE slug = p_project_slug
  LIMIT 1;

  IF v_project_id IS NULL OR v_status <> 'published' THEN
    RETURN '[]'::jsonb;
  END IF;

  SELECT coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', pm.id,
        'title', coalesce(pm.title, 'Documento del proyecto'),
        'storage_path', pm.storage_path,
        'url', '/storage/v1/object/public/' || pm.bucket_id || '/' || pm.storage_path,
        'mime_type', pm.mime_type,
        'size_bytes', pm.size_bytes,
        'updated_at', pm.created_at
      )
      ORDER BY pm.sort_order ASC, pm.created_at DESC
    ),
    '[]'::jsonb
  )
  INTO v_result
  FROM public.project_media pm
  WHERE pm.project_id = v_project_id
    AND pm.media_type = 'document'
    AND pm.is_public = true;

  RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.get_project_documents(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_project_documents(text) TO anon, authenticated, service_role;

