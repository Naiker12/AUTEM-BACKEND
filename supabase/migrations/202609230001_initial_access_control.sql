CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE public.app_role AS ENUM (
  'superadmin',
  'administrador',
  'editor',
  'comercial'
);

CREATE TYPE public.project_member_role AS ENUM (
  'manager',
  'editor',
  'viewer'
);

CREATE TYPE public.project_status AS ENUM (
  'draft',
  'published',
  'archived'
);

CREATE TABLE public.organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text,
  avatar_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.organization_members (
  organization_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.app_role NOT NULL DEFAULT 'editor',
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (organization_id, user_id)
);

CREATE TABLE public.projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  slug text NOT NULL,
  name text NOT NULL,
  status public.project_status NOT NULL DEFAULT 'draft',
  location text,
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (organization_id, slug)
);

CREATE TABLE public.project_members (
  project_id uuid NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.project_member_role NOT NULL DEFAULT 'viewer',
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (project_id, user_id)
);

CREATE OR REPLACE FUNCTION public.is_superadmin(target_organization_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.organization_members
    WHERE organization_id = target_organization_id
      AND user_id = auth.uid()
      AND role = 'superadmin'
  );
$$;

CREATE OR REPLACE FUNCTION public.can_manage_organization(target_organization_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.organization_members
    WHERE organization_id = target_organization_id
      AND user_id = auth.uid()
      AND role IN ('superadmin', 'administrador')
  );
$$;

CREATE OR REPLACE FUNCTION public.is_organization_member(target_organization_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.organization_members
    WHERE organization_id = target_organization_id
      AND user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.can_view_profile(target_user_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT target_user_id = auth.uid()
  OR EXISTS (
    SELECT 1
    FROM public.organization_members AS target_member
    JOIN public.organization_members AS current_member
      ON current_member.organization_id = target_member.organization_id
    WHERE target_member.user_id = target_user_id
      AND current_member.user_id = auth.uid()
  );
$$;

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
  );
$$;

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

CREATE OR REPLACE FUNCTION public.can_manage_project_members(target_project_id uuid)
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
      AND role = 'manager'
  );
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (new.id, new.raw_user_meta_data ->> 'full_name')
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.organizations, public.profiles, public.organization_members, public.projects, public.project_members FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organizations, public.profiles, public.organization_members, public.projects, public.project_members TO authenticated;
GRANT SELECT ON public.projects TO anon;

CREATE POLICY "Members can read visible profiles"
  ON public.profiles FOR SELECT TO authenticated
  USING (public.can_view_profile(id));

CREATE POLICY "Members can update their profile"
  ON public.profiles FOR UPDATE TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

CREATE POLICY "Authenticated users can read published projects"
  ON public.projects FOR SELECT TO authenticated
  USING (status = 'published' OR public.can_access_project(id));

CREATE POLICY "Public can read published projects"
  ON public.projects FOR SELECT TO anon
  USING (status = 'published');

CREATE POLICY "Organization members can read their organization"
  ON public.organizations FOR SELECT TO authenticated
  USING (public.is_organization_member(id));

CREATE POLICY "Authorized members can read project assignments"
  ON public.project_members FOR SELECT TO authenticated
  USING (public.can_access_project(project_id));

CREATE POLICY "Organization members can read their organization"
  ON public.organization_members FOR SELECT TO authenticated
  USING (public.is_organization_member(organization_id));

CREATE POLICY "Superadmins manage organization members"
  ON public.organization_members FOR ALL TO authenticated
  USING (public.is_superadmin(organization_id))
  WITH CHECK (public.is_superadmin(organization_id));

CREATE POLICY "Project managers manage project assignments"
  ON public.project_members FOR ALL TO authenticated
  USING (public.can_manage_project_members(project_id))
  WITH CHECK (public.can_manage_project_members(project_id));

CREATE POLICY "Authorized members manage projects"
  ON public.projects FOR INSERT TO authenticated
  WITH CHECK (public.can_manage_organization(organization_id));

CREATE POLICY "Authorized members update projects"
  ON public.projects FOR UPDATE TO authenticated
  USING (public.can_manage_project(id))
  WITH CHECK (public.can_manage_project(id));

CREATE POLICY "Superadmins delete projects"
  ON public.projects FOR DELETE TO authenticated
  USING (public.can_manage_organization(organization_id));

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('project-media', 'project-media', false, 52428800, ARRAY['image/jpeg', 'image/png', 'image/webp', 'application/pdf', 'video/mp4']),
  ('project-360', 'project-360', false, 524288000, ARRAY['image/jpeg', 'image/webp', 'video/mp4'])
ON CONFLICT (id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.project_id_from_storage_path(object_name text)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = ''
AS $$
DECLARE
  project_id_text text := split_part(object_name, '/', 1);
BEGIN
  IF project_id_text ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' THEN
    RETURN project_id_text::uuid;
  END IF;
  RETURN NULL;
END;
$$;

REVOKE ALL ON FUNCTION public.is_superadmin(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.can_manage_organization(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.is_organization_member(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.can_view_profile(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.can_access_project(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.can_manage_project(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.can_manage_project_members(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.project_id_from_storage_path(text) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.is_superadmin(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_manage_organization(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_organization_member(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_view_profile(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_access_project(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_manage_project(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.can_manage_project_members(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.project_id_from_storage_path(text) TO authenticated;

CREATE POLICY "Authorized members can view project media"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id IN ('project-media', 'project-360')
    AND public.can_access_project(public.project_id_from_storage_path(name))
  );

CREATE POLICY "Authorized members can upload project media"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id IN ('project-media', 'project-360')
    AND public.can_manage_project(public.project_id_from_storage_path(name))
  );

CREATE POLICY "Authorized members can update project media"
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id IN ('project-media', 'project-360')
    AND public.can_manage_project(public.project_id_from_storage_path(name))
  )
  WITH CHECK (
    bucket_id IN ('project-media', 'project-360')
    AND public.can_manage_project(public.project_id_from_storage_path(name))
  );

CREATE POLICY "Authorized members can delete project media"
  ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id IN ('project-media', 'project-360')
    AND public.can_manage_project(public.project_id_from_storage_path(name))
  );
