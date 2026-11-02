-- Reconciliation migration for AUTEM:
-- 1. audit_logs table and record_audit_event RPC
-- 2. update_lot_data RPC for safe, audited lot updates
-- 3. get_my_access RPC for fast, unified client auth lookup
-- 4. Enforce strict can_manage_organization (superadmin, administrador only)
-- 5. Revoke anonymous access to organization_members

-- 1. AUDIT LOGS TABLE & RLS
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  user_email text,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id text,
  project_id uuid REFERENCES public.projects(id) ON DELETE SET NULL,
  details jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS audit_logs_created_at_idx ON public.audit_logs (created_at DESC);
CREATE INDEX IF NOT EXISTS audit_logs_action_idx ON public.audit_logs (action);
CREATE INDEX IF NOT EXISTS audit_logs_project_id_idx ON public.audit_logs (project_id);

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "superadmins can view audit logs" ON public.audit_logs;
CREATE POLICY "superadmins can view audit logs"
  ON public.audit_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.organization_members om
      WHERE om.user_id = auth.uid() AND om.role = 'superadmin'
    )
  );

DROP POLICY IF EXISTS "authenticated users can insert audit logs" ON public.audit_logs;
CREATE POLICY "authenticated users can insert audit logs"
  ON public.audit_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid() OR user_id IS NULL
  );

-- RPC: record_audit_event
DROP FUNCTION IF EXISTS public.record_audit_event(text, text, text, uuid, jsonb);
DROP FUNCTION IF EXISTS public.record_audit_event(text, text, text, uuid);
DROP FUNCTION IF EXISTS public.record_audit_event(text, jsonb, uuid);
DROP FUNCTION IF EXISTS public.record_audit_event(text, jsonb);
DROP FUNCTION IF EXISTS public.record_audit_event;
CREATE OR REPLACE FUNCTION public.record_audit_event(
  p_action text,
  p_entity_type text,
  p_entity_id text DEFAULT NULL,
  p_project_id uuid DEFAULT NULL,
  p_details jsonb DEFAULT '{}'::jsonb
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_user_email text;
  v_log_id uuid;
BEGIN
  IF v_user_id IS NOT NULL THEN
    SELECT email INTO v_user_email FROM auth.users WHERE id = v_user_id;
  END IF;

  INSERT INTO public.audit_logs (
    user_id,
    user_email,
    action,
    entity_type,
    entity_id,
    project_id,
    details
  ) VALUES (
    v_user_id,
    v_user_email,
    p_action,
    p_entity_type,
    p_entity_id,
    p_project_id,
    coalesce(p_details, '{}'::jsonb)
  )
  RETURNING id INTO v_log_id;

  RETURN v_log_id;
END;
$$;

REVOKE ALL ON FUNCTION public.record_audit_event(text, text, text, uuid, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.record_audit_event(text, text, text, uuid, jsonb) TO authenticated, service_role;

-- Overload: record_audit_event(p_action text, p_details jsonb)
CREATE OR REPLACE FUNCTION public.record_audit_event(
  p_action text,
  p_details jsonb
)
RETURNS uuid
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.record_audit_event(p_action, 'system', NULL, NULL, p_details);
$$;

REVOKE ALL ON FUNCTION public.record_audit_event(text, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.record_audit_event(text, jsonb) TO authenticated, service_role;


-- 2. RPC: update_lot_data
DROP FUNCTION IF EXISTS public.update_lot_data(jsonb);
DROP FUNCTION IF EXISTS public.update_lot_data;
CREATE OR REPLACE FUNCTION public.update_lot_data(lot_data jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  elem jsonb;
  v_ext_id text;
  v_proj_id uuid;
  v_manzana text;
  v_area numeric;
  v_price bigint;
  v_status text;
  v_meta jsonb;
  v_updated_count integer := 0;
  v_user_id uuid := auth.uid();
BEGIN
  IF jsonb_typeof(lot_data) = 'object' THEN
    lot_data := jsonb_build_array(lot_data);
  END IF;

  IF jsonb_typeof(lot_data) <> 'array' THEN
    RAISE EXCEPTION 'lot_data must be a jsonb object or array of objects';
  END IF;

  FOR elem IN SELECT jsonb_array_elements(lot_data) LOOP
    v_ext_id := elem->>'external_id';
    IF v_ext_id IS NULL THEN
      CONTINUE;
    END IF;

    IF elem ? 'project_id' AND (elem->>'project_id') IS NOT NULL THEN
      v_proj_id := (elem->>'project_id')::uuid;
    ELSE
      SELECT project_id INTO v_proj_id
      FROM public.lots
      WHERE external_id = v_ext_id
      LIMIT 1;
    END IF;

    IF v_proj_id IS NULL THEN
      RAISE EXCEPTION 'Lot % not found in any project', v_ext_id;
    END IF;

    -- Permission check: superadmin or administrator of org, or manager/editor on project
    IF NOT (
      EXISTS (
        SELECT 1 FROM public.organization_members om
        JOIN public.projects p ON p.organization_id = om.organization_id
        WHERE p.id = v_proj_id AND om.user_id = v_user_id AND om.role IN ('superadmin', 'administrador')
      )
      OR
      EXISTS (
        SELECT 1 FROM public.project_members pm
        WHERE pm.project_id = v_proj_id AND pm.user_id = v_user_id AND pm.role IN ('manager', 'editor')
      )
    ) THEN
      RAISE EXCEPTION 'Permission denied to update lot in project %', v_proj_id;
    END IF;

    SELECT manzana, area_m2, price_cop, status, metadata
    INTO v_manzana, v_area, v_price, v_status, v_meta
    FROM public.lots
    WHERE project_id = v_proj_id AND external_id = v_ext_id;

    IF elem ? 'manzana' THEN
      v_manzana := elem->>'manzana';
    END IF;
    IF elem ? 'area_m2' AND (elem->>'area_m2') IS NOT NULL THEN
      v_area := (elem->>'area_m2')::numeric;
    END IF;
    IF elem ? 'price_cop' AND (elem->>'price_cop') IS NOT NULL THEN
      v_price := (elem->>'price_cop')::bigint;
    END IF;
    IF elem ? 'status' AND (elem->>'status') IS NOT NULL THEN
      v_status := elem->>'status';
    END IF;
    IF elem ? 'metadata' AND (elem->'metadata') IS NOT NULL THEN
      v_meta := elem->'metadata';
    END IF;

    UPDATE public.lots
    SET
      manzana = v_manzana,
      area_m2 = v_area,
      price_cop = v_price,
      status = v_status,
      metadata = v_meta,
      updated_at = now()
    WHERE project_id = v_proj_id AND external_id = v_ext_id;

    v_updated_count := v_updated_count + 1;
  END LOOP;

  RETURN jsonb_build_object(
    'status', 'success',
    'updated_count', v_updated_count
  );
END;
$$;

REVOKE ALL ON FUNCTION public.update_lot_data(jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.update_lot_data(jsonb) TO authenticated, service_role;


-- 3. RPC: get_my_access
DROP FUNCTION IF EXISTS public.get_my_access();
DROP FUNCTION IF EXISTS public.get_my_access;
CREATE OR REPLACE FUNCTION public.get_my_access()
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_org_id uuid;
  v_role text;
  v_is_superadmin boolean := false;
  v_project_ids uuid[] := array[]::uuid[];
BEGIN
  IF v_user_id IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT organization_id, role::text
  INTO v_org_id, v_role
  FROM public.organization_members
  WHERE user_id = v_user_id
  LIMIT 1;

  IF v_org_id IS NULL THEN
    RETURN NULL;
  END IF;

  v_is_superadmin := (v_role = 'superadmin');

  IF v_is_superadmin THEN
    SELECT coalesce(array_agg(id), array[]::uuid[])
    INTO v_project_ids
    FROM public.projects
    WHERE organization_id = v_org_id;
  ELSE
    SELECT coalesce(array_agg(project_id), array[]::uuid[])
    INTO v_project_ids
    FROM public.project_members
    WHERE user_id = v_user_id;
  END IF;

  RETURN jsonb_build_object(
    'user_id', v_user_id,
    'role', v_role,
    'organization_id', v_org_id,
    'is_superadmin', v_is_superadmin,
    'project_ids', coalesce(to_jsonb(v_project_ids), '[]'::jsonb)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_my_access() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_my_access() TO authenticated, service_role;


-- 4. ENFORCE STRICT can_manage_organization
CREATE OR REPLACE FUNCTION public.can_manage_organization(target_organization_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.organization_members membership
    WHERE membership.organization_id = target_organization_id
      AND membership.user_id = auth.uid()
      AND membership.role IN ('superadmin', 'administrador')
  );
$$;

REVOKE ALL ON FUNCTION public.can_manage_organization(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_manage_organization(uuid) TO authenticated;


-- 5. REVOKE ANONYMOUS SELECT FROM organization_members
REVOKE SELECT ON public.organization_members FROM anon;

