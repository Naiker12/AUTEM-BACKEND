-- Perfil personal: separado de los medios de proyectos y limitado al propietario.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('avatars', 'avatars', false, 2097152, ARRAY['image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Users can read their own avatar"
  ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'avatars' AND (storage.foldername(name))[1] = (select auth.uid()::text));

CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'avatars' AND (storage.foldername(name))[1] = (select auth.uid()::text));

CREATE POLICY "Users can update their own avatar"
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'avatars' AND (storage.foldername(name))[1] = (select auth.uid()::text))
  WITH CHECK (bucket_id = 'avatars' AND (storage.foldername(name))[1] = (select auth.uid()::text));

CREATE POLICY "Users can delete their own avatar"
  ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'avatars' AND (storage.foldername(name))[1] = (select auth.uid()::text));

CREATE POLICY "Users can create their own profile"
  ON public.profiles FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());
