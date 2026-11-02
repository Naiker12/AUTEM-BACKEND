CREATE TABLE public.access_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz NOT NULL DEFAULT (now() + interval '1 hour'),
  accepted_at timestamptz,
  last_resent_at timestamptz,
  resend_count integer NOT NULL DEFAULT 0 CHECK (resend_count >= 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (organization_id, user_id)
);

ALTER TABLE public.access_invitations ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.access_invitations FROM anon;
GRANT SELECT ON public.access_invitations TO authenticated;

CREATE POLICY "Superadmins can read organization invitations"
  ON public.access_invitations FOR SELECT TO authenticated
  USING (private.is_superadmin(organization_id));

CREATE OR REPLACE FUNCTION public.mark_access_invitation_accepted()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF new.email_confirmed_at IS NOT NULL AND old.email_confirmed_at IS NULL THEN
    UPDATE public.access_invitations
    SET accepted_at = new.email_confirmed_at, updated_at = now()
    WHERE user_id = new.id AND accepted_at IS NULL;
  END IF;
  RETURN new;
END;
$$;

CREATE TRIGGER on_auth_user_email_confirmed
  AFTER UPDATE OF email_confirmed_at ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.mark_access_invitation_accepted();

REVOKE ALL ON FUNCTION public.mark_access_invitation_accepted() FROM PUBLIC;
