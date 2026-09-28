import { createClient } from "jsr:@supabase/supabase-js@2";

type InvitePayload = {
  email: string;
  fullName: string;
  organizationId: string;
  role: "superadmin" | "administrador" | "editor" | "comercial";
  projectIds?: string[];
};

const organizationRoles = new Set<InvitePayload["role"]>([
  "superadmin",
  "administrador",
  "editor",
  "comercial",
]);

const corsHeaders = {
  "Access-Control-Allow-Origin": Deno.env.get("PUBLIC_SITE_URL") ?? "http://127.0.0.1:5173",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (request.method !== "POST") {
    return Response.json({ error: "Método no permitido." }, { status: 405, headers: corsHeaders });
  }

  const authorization = request.headers.get("Authorization");
  if (!authorization?.startsWith("Bearer ")) {
    return Response.json({ error: "Sesión requerida." }, { status: 401, headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return Response.json({ error: "Configuración de servidor incompleta." }, { status: 500, headers: corsHeaders });
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  const token = authorization.replace("Bearer ", "");
  const { data: caller, error: callerError } = await admin.auth.getUser(token);
  if (callerError || !caller.user) {
    return Response.json({ error: "Sesión inválida." }, { status: 401, headers: corsHeaders });
  }

  let payload: InvitePayload;
  try {
    payload = (await request.json()) as InvitePayload;
  } catch {
    return Response.json({ error: "El cuerpo de la solicitud no es válido." }, { status: 400, headers: corsHeaders });
  }

  if (
    !payload ||
    typeof payload !== "object" ||
    !payload.email ||
    !payload.fullName ||
    !payload.organizationId ||
    !payload.role
  ) {
    return Response.json({ error: "Datos de invitación incompletos." }, { status: 400, headers: corsHeaders });
  }
  if (!organizationRoles.has(payload.role)) {
    return Response.json({ error: "El rol solicitado no es válido." }, { status: 400, headers: corsHeaders });
  }

  const projectIds = [...new Set(payload.projectIds ?? [])];
  if (projectIds.length && payload.role === "superadmin") {
    return Response.json(
      { error: "Un superadministrador no requiere asignaciones de proyecto." },
      { status: 400, headers: corsHeaders },
    );
  }

  const { data: membership } = await admin
    .from("organization_members")
    .select("role")
    .eq("organization_id", payload.organizationId)
    .eq("user_id", caller.user.id)
    .maybeSingle();
  if (membership?.role !== "superadmin") {
    return Response.json({ error: "No tienes permiso para invitar usuarios." }, { status: 403, headers: corsHeaders });
  }

  if (projectIds.length) {
    const { data: scopedProjects, error: scopedProjectsError } = await admin
      .from("projects")
      .select("id")
      .eq("organization_id", payload.organizationId)
      .in("id", projectIds);
    if (scopedProjectsError || scopedProjects?.length !== projectIds.length) {
      return Response.json(
        { error: "Una o más asignaciones no pertenecen a esta organización." },
        { status: 400, headers: corsHeaders },
      );
    }
  }

  const { data: invited, error: inviteError } = await admin.auth.admin.inviteUserByEmail(payload.email, {
    data: { full_name: payload.fullName },
    redirectTo: Deno.env.get("PUBLIC_SITE_URL"),
  });
  if (inviteError || !invited.user) {
    return Response.json({ error: inviteError?.message ?? "No fue posible crear la invitación." }, { status: 400, headers: corsHeaders });
  }

  const { error: organizationError } = await admin.from("organization_members").upsert({
    organization_id: payload.organizationId,
    user_id: invited.user.id,
    role: payload.role,
  });
  if (organizationError) {
    return Response.json({ error: "La invitación fue creada, pero no se pudo asignar el rol." }, { status: 500, headers: corsHeaders });
  }

  if (payload.role !== "superadmin" && projectIds.length) {
    const rows = projectIds.map((projectId) => ({
      project_id: projectId,
      user_id: invited.user.id,
      role: payload.role === "administrador" ? "manager" : payload.role === "editor" ? "editor" : "viewer",
    }));
    const { error: projectError } = await admin.from("project_members").upsert(rows);
    if (projectError) {
      return Response.json({ error: "La invitación fue creada, pero no se pudo asignar el proyecto." }, { status: 500, headers: corsHeaders });
    }
  }

  return Response.json({ userId: invited.user.id, status: "invited" }, { headers: corsHeaders });
});
