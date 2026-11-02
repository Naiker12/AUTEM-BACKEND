-- Bootstrap controlado: debe ejecutarse después de crear la cuenta en Supabase Auth.
-- Es idempotente para que el rol se pueda verificar o reaplicar sin duplicar membresías.
DO $$
DECLARE
  bootstrap_user_id uuid;
  autem_organization_id uuid := '00000000-0000-0000-0000-000000000001';
BEGIN
  SELECT id
  INTO bootstrap_user_id
  FROM auth.users
  WHERE lower(email) = lower('naikergomez0123@gmail.com');

  IF NOT EXISTS (SELECT 1 FROM public.organizations WHERE id = autem_organization_id) THEN
    RAISE EXCEPTION 'The AUTEM organization must exist before assigning its first superadmin.';
  END IF;

  IF bootstrap_user_id IS NOT NULL THEN
    INSERT INTO public.organization_members (organization_id, user_id, role)
    VALUES (autem_organization_id, bootstrap_user_id, 'superadmin')
    ON CONFLICT (organization_id, user_id)
    DO UPDATE SET role = EXCLUDED.role;
  ELSE
    RAISE NOTICE 'The bootstrap superadmin account (naikergomez0123@gmail.com) does not exist yet in auth.users. The role will be assigned once created.';
  END IF;
END;
$$;
