-- Las funciones de autorización son dependencias de RLS, no endpoints públicos.
-- Moverlas a un esquema privado elimina su exposición por la Data API.
CREATE SCHEMA IF NOT EXISTS private;
REVOKE ALL ON SCHEMA private FROM PUBLIC;

ALTER FUNCTION public.is_superadmin(uuid) SET SCHEMA private;
ALTER FUNCTION public.can_manage_organization(uuid) SET SCHEMA private;
ALTER FUNCTION public.is_organization_member(uuid) SET SCHEMA private;
ALTER FUNCTION public.can_view_profile(uuid) SET SCHEMA private;
ALTER FUNCTION public.can_access_project(uuid) SET SCHEMA private;
ALTER FUNCTION public.can_manage_project(uuid) SET SCHEMA private;
ALTER FUNCTION public.can_manage_project_members(uuid) SET SCHEMA private;
ALTER FUNCTION public.handle_new_user() SET SCHEMA private;
ALTER FUNCTION public.project_id_from_storage_path(text) SET SCHEMA private;

REVOKE ALL ON FUNCTION private.is_superadmin(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.can_manage_organization(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.is_organization_member(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.can_view_profile(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.can_access_project(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.can_manage_project(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.can_manage_project_members(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION private.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION private.project_id_from_storage_path(text) FROM PUBLIC, anon;

GRANT USAGE ON SCHEMA private TO authenticated;
GRANT EXECUTE ON FUNCTION private.is_superadmin(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.can_manage_organization(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.is_organization_member(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.can_view_profile(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.can_access_project(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.can_manage_project(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.can_manage_project_members(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION private.project_id_from_storage_path(text) TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
