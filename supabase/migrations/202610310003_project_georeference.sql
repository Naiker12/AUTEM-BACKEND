-- 202610310003_project_georeference.sql
-- Table, RLS and RPCs for CAD/GIS project georeferencing and spatial coordinate transformation

CREATE TABLE IF NOT EXISTS public.project_georeference (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE UNIQUE,
  srid integer NOT NULL DEFAULT 3116,
  status text NOT NULL DEFAULT 'missing' CHECK (status IN ('missing', 'draft', 'validated')),
  cad_units text NOT NULL DEFAULT 'meters',
  origin_cad jsonb DEFAULT '{"x": 0, "y": 0}'::jsonb,
  origin_geo jsonb DEFAULT NULL,
  rotation_deg double precision DEFAULT 0,
  scale_factor double precision DEFAULT 1.0,
  affine_transform jsonb DEFAULT NULL,
  bounds_geo jsonb DEFAULT NULL,
  control_points jsonb NOT NULL DEFAULT '[]'::jsonb,
  notes text,
  validated_at timestamptz,
  validated_by uuid REFERENCES auth.users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS project_georeference_set_updated_at ON public.project_georeference;
CREATE TRIGGER project_georeference_set_updated_at
  BEFORE UPDATE ON public.project_georeference
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.project_georeference ENABLE ROW LEVEL SECURITY;

-- Helper: can_manage_project
CREATE OR REPLACE FUNCTION public.can_manage_project(target_project_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.projects
    JOIN public.organization_members
      ON organization_members.organization_id = projects.organization_id
    WHERE projects.id = target_project_id
      AND organization_members.user_id = auth.uid()
      AND organization_members.role IN ('superadmin', 'administrador')
  )
  OR EXISTS (
    SELECT 1
    FROM public.project_members
    WHERE project_id = target_project_id
      AND user_id = auth.uid()
      AND role IN ('manager', 'editor')
  );
$$;

REVOKE ALL ON FUNCTION public.can_manage_project(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_manage_project(uuid) TO authenticated;

-- Helper: can_access_project
CREATE OR REPLACE FUNCTION public.can_access_project(target_project_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.projects
    WHERE id = target_project_id
      AND status = 'published'
  )
  OR EXISTS (
    SELECT 1
    FROM public.projects
    JOIN public.organization_members
      ON organization_members.organization_id = projects.organization_id
    WHERE projects.id = target_project_id
      AND organization_members.user_id = auth.uid()
  )
  OR EXISTS (
    SELECT 1
    FROM public.project_members
    WHERE project_id = target_project_id
      AND user_id = auth.uid()
  );
$$;

REVOKE ALL ON FUNCTION public.can_access_project(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_access_project(uuid) TO authenticated;

-- 1. Visitors can view validated georeferences of published projects
DROP POLICY IF EXISTS "public can view validated georeference of published projects" ON public.project_georeference;
CREATE POLICY "public can view validated georeference of published projects"
  ON public.project_georeference
  FOR SELECT
  TO anon, authenticated
  USING (
    status = 'validated'
    AND EXISTS (
      SELECT 1 FROM public.projects p
      WHERE p.id = project_georeference.project_id
        AND p.status = 'published'
    )
  );

-- 2. Authenticated team members can view georeference if they belong to project org
DROP POLICY IF EXISTS "members can view project georeference" ON public.project_georeference;
CREATE POLICY "members can view project georeference"
  ON public.project_georeference
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.projects p
      JOIN public.organization_members m ON m.organization_id = p.organization_id
      WHERE p.id = project_georeference.project_id
        AND m.user_id = auth.uid()
    )
  );

-- 3. Managers can manage project georeference
DROP POLICY IF EXISTS "managers can manage project georeference" ON public.project_georeference;
CREATE POLICY "managers can manage project georeference"
  ON public.project_georeference
  FOR ALL
  TO authenticated
  USING (public.can_manage_project(project_id))
  WITH CHECK (public.can_manage_project(project_id));

GRANT SELECT ON public.project_georeference TO anon, authenticated;
GRANT ALL ON public.project_georeference TO authenticated;

-- RPC: get_project_georeference
DROP FUNCTION IF EXISTS public.get_project_georeference(text);
DROP FUNCTION IF EXISTS public.get_project_georeference;
CREATE OR REPLACE FUNCTION public.get_project_georeference(p_project_slug text)
RETURNS TABLE (
  id uuid,
  project_id uuid,
  srid integer,
  status text,
  cad_units text,
  origin_cad jsonb,
  origin_geo jsonb,
  rotation_deg double precision,
  scale_factor double precision,
  affine_transform jsonb,
  bounds_geo jsonb,
  control_points jsonb,
  notes text,
  validated_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    g.id,
    g.project_id,
    g.srid,
    g.status,
    g.cad_units,
    g.origin_cad,
    g.origin_geo,
    g.rotation_deg,
    g.scale_factor,
    g.affine_transform,
    g.bounds_geo,
    g.control_points,
    g.notes,
    g.validated_at
  FROM public.project_georeference g
  JOIN public.projects p ON p.id = g.project_id
  WHERE p.slug = p_project_slug
    AND (
      (p.status = 'published' AND g.status = 'validated')
      OR (auth.uid() IS NOT NULL AND public.can_access_project(p.id))
    )
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.get_project_georeference(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_project_georeference(text) TO anon, authenticated;

-- RPC: save_project_georeference
DROP FUNCTION IF EXISTS public.save_project_georeference;
CREATE OR REPLACE FUNCTION public.save_project_georeference(
  p_project_id uuid,
  p_srid integer DEFAULT 3116,
  p_status text DEFAULT 'draft',
  p_cad_units text DEFAULT 'meters',
  p_origin_cad jsonb DEFAULT '{"x": 0, "y": 0}'::jsonb,
  p_origin_geo jsonb DEFAULT NULL,
  p_rotation_deg double precision DEFAULT 0,
  p_scale_factor double precision DEFAULT 1.0,
  p_control_points jsonb DEFAULT '[]'::jsonb,
  p_affine_transform jsonb DEFAULT NULL,
  p_bounds_geo jsonb DEFAULT NULL,
  p_notes text DEFAULT NULL
)
RETURNS public.project_georeference
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_result public.project_georeference;
  v_user_id uuid := auth.uid();
  v_validated_at timestamptz := NULL;
  v_validated_by uuid := NULL;
BEGIN
  IF v_user_id IS NULL OR NOT public.can_manage_project(p_project_id) THEN
    RAISE EXCEPTION 'Not authorized to manage georeference for this project';
  END IF;

  IF p_status NOT IN ('missing', 'draft', 'validated') THEN
    RAISE EXCEPTION 'Invalid status. Allowed: missing, draft, validated';
  END IF;

  IF p_status = 'validated' THEN
    v_validated_at := clock_timestamp();
    v_validated_by := v_user_id;
  END IF;

  INSERT INTO public.project_georeference (
    project_id,
    srid,
    status,
    cad_units,
    origin_cad,
    origin_geo,
    rotation_deg,
    scale_factor,
    control_points,
    affine_transform,
    bounds_geo,
    notes,
    validated_at,
    validated_by
  )
  VALUES (
    p_project_id,
    COALESCE(p_srid, 3116),
    p_status,
    COALESCE(p_cad_units, 'meters'),
    COALESCE(p_origin_cad, '{"x": 0, "y": 0}'::jsonb),
    p_origin_geo,
    COALESCE(p_rotation_deg, 0),
    COALESCE(p_scale_factor, 1.0),
    COALESCE(p_control_points, '[]'::jsonb),
    p_affine_transform,
    p_bounds_geo,
    p_notes,
    v_validated_at,
    v_validated_by
  )
  ON CONFLICT (project_id) DO UPDATE SET
    srid = EXCLUDED.srid,
    status = EXCLUDED.status,
    cad_units = EXCLUDED.cad_units,
    origin_cad = EXCLUDED.origin_cad,
    origin_geo = EXCLUDED.origin_geo,
    rotation_deg = EXCLUDED.rotation_deg,
    scale_factor = EXCLUDED.scale_factor,
    control_points = EXCLUDED.control_points,
    affine_transform = EXCLUDED.affine_transform,
    bounds_geo = EXCLUDED.bounds_geo,
    notes = EXCLUDED.notes,
    validated_at = CASE WHEN EXCLUDED.status = 'validated' THEN clock_timestamp() ELSE project_georeference.validated_at END,
    validated_by = CASE WHEN EXCLUDED.status = 'validated' THEN v_user_id ELSE project_georeference.validated_by END,
    updated_at = clock_timestamp()
  RETURNING * INTO v_result;

  -- Audit log entry
  PERFORM public.record_audit_event(
    CASE WHEN p_status = 'validated' THEN 'project.georeference_validated' ELSE 'project.georeference_saved' END,
    jsonb_build_object(
      'project_id', p_project_id,
      'status', p_status,
      'srid', p_srid,
      'control_points_count', jsonb_array_length(COALESCE(p_control_points, '[]'::jsonb))
    )
  );

  RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.save_project_georeference(uuid, integer, text, text, jsonb, jsonb, double precision, double precision, jsonb, jsonb, jsonb, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_project_georeference(uuid, integer, text, text, jsonb, jsonb, double precision, double precision, jsonb, jsonb, jsonb, text) TO authenticated;

