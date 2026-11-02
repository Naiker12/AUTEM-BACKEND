import { createClient } from "jsr:@supabase/supabase-js@2";

type ActionType = "invite" | "list" | "resend" | "update" | "remove";

type InvitePayload = {
  action?: ActionType;
  organizationId: string;
  userId?: string;
  email?: string;
  fullName?: string;
  role?: "superadmin" | "administrador" | "editor" | "comercial";
  projectIds?: string[];
};

const VALID_ROLES = new Set<string>([
  "superadmin",
  "administrador",
  "editor",
  "comercial",
]);

function getCorsHeaders(origin: string | null) {
  const configuredUrls =
    Deno.env.get("PUBLIC_SITE_URLS") ??
    Deno.env.get("PUBLIC_SITE_URL") ??
    "http://127.0.0.1:5173,http://localhost:5173";

  const allowedPatterns = configuredUrls
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);

  let matchedOrigin = allowedPatterns[0] || "http://127.0.0.1:5173";

  if (origin) {
    const isAllowed = allowedPatterns.some((pattern) => {
      if (pattern === "*" || pattern === origin) return true;
      if (pattern.includes("*")) {
        const escaped = pattern.replace(/\./g, "\\.").replace(/\*/g, ".*");
        return new RegExp(`^${escaped}$`).test(origin);
      }
      return false;
    });

    if (isAllowed) {
      matchedOrigin = origin;
    }
  }

  return {
    "Access-Control-Allow-Origin": matchedOrigin,
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Max-Age": "86400",
  };
}

function getInvitationRedirectUrl() {
  const siteUrl = Deno.env.get("PUBLIC_SITE_URL") ?? "http://127.0.0.1:5173";
  return new URL("/actualizar-contrasena", siteUrl).toString();
}

Deno.serve(async (request) => {
  const corsHeaders = getCorsHeaders(request.headers.get("origin"));

  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (request.method !== "POST") {
    return Response.json(
      { error: "Método no permitido.", code: "METHOD_NOT_ALLOWED" },
      { status: 405, headers: corsHeaders }
    );
  }

  const authorization = request.headers.get("Authorization");
  if (!authorization?.startsWith("Bearer ")) {
    return Response.json(
      { error: "Sesión requerida.", code: "UNAUTHORIZED" },
      { status: 401, headers: corsHeaders }
    );
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return Response.json(
      { error: "Configuración de servidor incompleta.", code: "SERVER_CONFIG_ERROR" },
      { status: 500, headers: corsHeaders }
    );
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const token = authorization.replace("Bearer ", "");
  const { data: caller, error: callerError } = await admin.auth.getUser(token);
  if (callerError || !caller.user) {
    return Response.json(
      { error: "Sesión inválida o expirada.", code: "INVALID_SESSION" },
      { status: 401, headers: corsHeaders }
    );
  }

  let payload: InvitePayload;
  try {
    payload = (await request.json()) as InvitePayload;
  } catch {
    return Response.json(
      { error: "El cuerpo de la solicitud no es un JSON válido.", code: "INVALID_BODY" },
      { status: 400, headers: corsHeaders }
    );
  }

  if (!payload || typeof payload !== "object" || !payload.organizationId) {
    return Response.json(
      { error: "El identificador de la organización es obligatorio.", code: "MISSING_ORG_ID" },
      { status: 400, headers: corsHeaders }
    );
  }

  const action: ActionType = payload.action ?? "invite";
  if (!["invite", "list", "resend", "update", "remove"].includes(action)) {
    return Response.json(
      { error: "Acción no válida.", code: "INVALID_ACTION" },
      { status: 400, headers: corsHeaders }
    );
  }

  // Verificar pertenencia y rol del usuario que llama
  const { data: membership, error: membershipError } = await admin
    .from("organization_members")
    .select("role")
    .eq("organization_id", payload.organizationId)
    .eq("user_id", caller.user.id)
    .maybeSingle();

  if (membershipError || !membership) {
    return Response.json(
      { error: "No tienes membresía en esta organización.", code: "NOT_AN_ORG_MEMBER" },
      { status: 403, headers: corsHeaders }
    );
  }

  const callerRole = membership.role;
  const isSuperadmin = callerRole === "superadmin";
  const isAdministrator = callerRole === "administrador";

  if (!isSuperadmin && !isAdministrator) {
    return Response.json(
      { error: "No tienes permiso para gestionar usuarios ni ver el equipo.", code: "FORBIDDEN" },
      { status: 403, headers: corsHeaders }
    );
  }

  // Proyectos que administra si es rol administrador
  const managedProjectIds = isAdministrator
    ? (
        await admin
          .from("project_members")
          .select("project_id")
          .eq("user_id", caller.user.id)
          .eq("role", "manager")
      ).data?.map((item) => item.project_id) ?? []
    : [];

  const ensureAdministratorScope = (targetRole?: string, targetProjectIds?: string[]) => {
    if (!isAdministrator) return null;
    if (targetRole && !["editor", "comercial"].includes(targetRole)) {
      return "Un administrador solo puede gestionar roles operativos (editor o comercial).";
    }
    if (
      targetProjectIds &&
      targetProjectIds.length > 0 &&
      targetProjectIds.some((projectId) => !managedProjectIds.includes(projectId))
    ) {
      return "Solo puedes asignar proyectos que tú administras activamente.";
    }
    return null;
  };

  // Helper para auditoría desde el backend
  const audit = async (
    eventAction: string,
    entityId: string | null,
    projectId: string | null,
    details: Record<string, unknown>
  ) => {
    try {
      await admin.rpc("record_audit_event", {
        p_action: eventAction,
        p_entity_type: "team_member",
        p_entity_id: entityId,
        p_project_id: projectId,
        p_details: details,
      });
    } catch {
      // Fallback a inserción directa si la RPC aún se está sincronizando
      await admin.from("audit_logs").insert({
        user_id: caller.user.id,
        user_email: caller.user.email,
        action: eventAction,
        entity_type: "team_member",
        entity_id: entityId,
        project_id: projectId,
        details,
      });
    }
  };

  // ==========================================
  // ACCIÓN 1: LISTAR MIEMBROS DEL EQUIPO
  // ==========================================
  if (action === "list") {
    const { data: members, error: membersError } = await admin
      .from("organization_members")
      .select("user_id, role")
      .eq("organization_id", payload.organizationId);

    if (membersError) {
      return Response.json(
        { error: "No fue posible consultar los miembros de la organización.", code: "LIST_ERROR" },
        { status: 500, headers: corsHeaders }
      );
    }

    const memberIds = (members ?? []).map((m) => m.user_id);
    if (memberIds.length === 0) {
      return Response.json({ members: [] }, { headers: corsHeaders });
    }

    const [profilesRes, projectAssignmentsRes, invitationsRes] = await Promise.all([
      admin.from("profiles").select("id, full_name").in("id", memberIds),
      admin.from("project_members").select("user_id, project_id").in("user_id", memberIds),
      admin
        .from("access_invitations")
        .select("user_id, sent_at, expires_at, accepted_at, last_resent_at, resend_count")
        .eq("organization_id", payload.organizationId),
    ]);

    const projectIds = [
      ...new Set((projectAssignmentsRes.data ?? []).map((assignment) => assignment.project_id)),
    ];

    const projectsRes = projectIds.length
      ? await admin.from("projects").select("id, name").in("id", projectIds)
      : { data: [], error: null };

    const profileByUser = new Map((profilesRes.data ?? []).map((p) => [p.id, p]));
    const projectNameById = new Map((projectsRes.data ?? []).map((p) => [p.id, p.name]));
    const projectsByUser = new Map<string, string[]>();
    const projectIdsByUser = new Map<string, string[]>();

    for (const assignment of projectAssignmentsRes.data ?? []) {
      const projectName = projectNameById.get(assignment.project_id);
      if (!projectName) continue;

      projectsByUser.set(assignment.user_id, [
        ...(projectsByUser.get(assignment.user_id) ?? []),
        projectName,
      ]);
      projectIdsByUser.set(assignment.user_id, [
        ...(projectIdsByUser.get(assignment.user_id) ?? []),
        assignment.project_id,
      ]);
    }

    const invitationByUser = new Map(
      (invitationsRes.data ?? []).map((item) => [item.user_id, item])
    );

    const results = await Promise.all(
      (members ?? []).map(async (member) => {
        const { data: userData } = await admin.auth.admin.getUserById(member.user_id);
        const invitation = invitationByUser.get(member.user_id);
        const userProjects =
          member.role === "superadmin"
            ? ["Todos los proyectos"]
            : projectsByUser.get(member.user_id) ?? [];
        const userProjectIds = projectIdsByUser.get(member.user_id) ?? [];

        return {
          id: member.user_id,
          name:
            profileByUser.get(member.user_id)?.full_name ??
            userData?.user?.user_metadata?.full_name ??
            "Sin nombre asignado",
          email: userData?.user?.email ?? "",
          role: member.role,
          projects: userProjects,
          projectIds: userProjectIds,
          emailConfirmedAt: userData?.user?.email_confirmed_at ?? null,
          invitation: invitation
            ? {
                sentAt: invitation.sent_at,
                expiresAt: invitation.expires_at,
                acceptedAt: invitation.accepted_at,
                lastResentAt: invitation.last_resent_at,
                resendCount: invitation.resend_count ?? 0,
              }
            : null,
        };
      })
    );

    const filteredResults = isSuperadmin
      ? results
      : results.filter((m) =>
          (projectIdsByUser.get(m.id) ?? []).some((pid) => managedProjectIds.includes(pid))
        );

    return Response.json({ members: filteredResults }, { headers: corsHeaders });
  }

  // ==========================================
  // ACCIÓN 2: REENVIAR INVITACIÓN
  // ==========================================
  if (action === "resend") {
    if (!payload.userId) {
      return Response.json(
        { error: "Identificador de usuario requerido.", code: "MISSING_USER_ID" },
        { status: 400, headers: corsHeaders }
      );
    }

    const { data: invitation, error: invitationError } = await admin
      .from("access_invitations")
      .select("user_id, email, accepted_at, last_resent_at, resend_count")
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId)
      .maybeSingle();

    if (invitationError || !invitation) {
      return Response.json(
        { error: "No se encontró una invitación registrada para este usuario.", code: "INVITATION_NOT_FOUND" },
        { status: 404, headers: corsHeaders }
      );
    }

    if (invitation.accepted_at) {
      return Response.json(
        { error: "Esta persona ya activó su acceso y cuenta.", code: "ALREADY_ACTIVE" },
        { status: 400, headers: corsHeaders }
      );
    }

    if (isAdministrator) {
      const { data: targetMember } = await admin
        .from("organization_members")
        .select("role")
        .eq("organization_id", payload.organizationId)
        .eq("user_id", invitation.user_id)
        .maybeSingle();

      if (!targetMember || !["editor", "comercial"].includes(targetMember.role)) {
        return Response.json(
          { error: "No tienes permiso para gestionar invitaciones de este nivel de acceso.", code: "FORBIDDEN" },
          { status: 403, headers: corsHeaders }
        );
      }
    }

    if (
      invitation.last_resent_at &&
      Date.now() - new Date(invitation.last_resent_at).getTime() < 60_000
    ) {
      return Response.json(
        { error: "Por favor espera 1 minuto antes de reenviar nuevamente la invitación.", code: "RATE_LIMITED" },
        { status: 429, headers: corsHeaders }
      );
    }

    const { error: resendError } = await admin.auth.admin.inviteUserByEmail(invitation.email, {
      redirectTo: getInvitationRedirectUrl(),
    });

    if (resendError) {
      return Response.json(
        { error: resendError.message, code: "RESEND_FAILED" },
        { status: 400, headers: corsHeaders }
      );
    }

    const nowIso = new Date().toISOString();
    await admin
      .from("access_invitations")
      .update({
        sent_at: nowIso,
        expires_at: new Date(Date.now() + 60 * 60 * 1000).toISOString(),
        last_resent_at: nowIso,
        resend_count: (invitation.resend_count ?? 0) + 1,
        updated_at: nowIso,
      })
      .eq("organization_id", payload.organizationId)
      .eq("user_id", invitation.user_id);

    await audit("team:resend_invitation", invitation.user_id, null, {
      memberEmail: invitation.email,
    });

    return Response.json({ status: "resent" }, { headers: corsHeaders });
  }

  // ==========================================
  // ACCIÓN 3: ACTUALIZAR ROL Y ALCANCE
  // ==========================================
  if (action === "update") {
    if (!payload.userId || !payload.role) {
      return Response.json(
        { error: "Identificador de usuario y rol son obligatorios.", code: "MISSING_FIELDS" },
        { status: 400, headers: corsHeaders }
      );
    }

    if (!VALID_ROLES.has(payload.role)) {
      return Response.json(
        { error: "El rol solicitado no es válido.", code: "INVALID_ROLE" },
        { status: 400, headers: corsHeaders }
      );
    }

    if (payload.userId === caller.user.id) {
      return Response.json(
        { error: "No puedes modificar tu propio rol o permisos.", code: "CANNOT_MODIFY_SELF" },
        { status: 400, headers: corsHeaders }
      );
    }

    const { data: targetMember } = await admin
      .from("organization_members")
      .select("role")
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId)
      .maybeSingle();

    if (!targetMember) {
      return Response.json(
        { error: "No se encontró el miembro en la organización.", code: "USER_NOT_FOUND" },
        { status: 404, headers: corsHeaders }
      );
    }

    // Regla de seguridad: Impedir dejar la organización sin superadmin
    if (targetMember.role === "superadmin" && payload.role !== "superadmin") {
      const { count } = await admin
        .from("organization_members")
        .select("*", { count: "exact", head: true })
        .eq("organization_id", payload.organizationId)
        .eq("role", "superadmin");

      if ((count ?? 0) <= 1) {
        return Response.json(
          {
            error: "No es posible degradar al único superadministrador de la organización.",
            code: "LAST_SUPERADMIN",
          },
          { status: 400, headers: corsHeaders }
        );
      }
    }

    const projectIds = [...new Set(payload.projectIds ?? [])];
    const scopeError = ensureAdministratorScope(payload.role, projectIds);
    if (scopeError) {
      return Response.json(
        { error: scopeError, code: "SCOPE_VIOLATION" },
        { status: 403, headers: corsHeaders }
      );
    }

    // Actualizar rol en la organización
    const { error: updateMemberError } = await admin
      .from("organization_members")
      .update({ role: payload.role })
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId);

    if (updateMemberError) {
      return Response.json(
        { error: "No fue posible actualizar el rol.", code: "UPDATE_ERROR" },
        { status: 500, headers: corsHeaders }
      );
    }

    // Sincronizar membresías de proyectos en esta organización
    const orgProjects =
      (
        await admin
          .from("projects")
          .select("id")
          .eq("organization_id", payload.organizationId)
      ).data?.map((p) => p.id) ?? [];

    if (orgProjects.length > 0) {
      await admin
        .from("project_members")
        .delete()
        .eq("user_id", payload.userId)
        .in("project_id", orgProjects);
    }

    if (payload.role !== "superadmin" && projectIds.length > 0) {
      const projectRows = projectIds.map((projectId) => ({
        project_id: projectId,
        user_id: payload.userId,
        role:
          payload.role === "administrador"
            ? "manager"
            : payload.role === "editor"
              ? "editor"
              : "viewer",
      }));

      await admin.from("project_members").upsert(projectRows);
    }

    await audit("team:update_member_access", payload.userId, projectIds[0] ?? null, {
      newRole: payload.role,
      previousRole: targetMember.role,
      projectIds,
    });

    return Response.json({ status: "updated" }, { headers: corsHeaders });
  }

  // ==========================================
  // ACCIÓN 4: RETIRAR ACCESO / ELIMINAR
  // ==========================================
  if (action === "remove") {
    if (!payload.userId) {
      return Response.json(
        { error: "Identificador de usuario requerido.", code: "MISSING_USER_ID" },
        { status: 400, headers: corsHeaders }
      );
    }

    if (payload.userId === caller.user.id) {
      return Response.json(
        { error: "No puedes retirar tu propio acceso ni autoeliminarte.", code: "CANNOT_REMOVE_SELF" },
        { status: 400, headers: corsHeaders }
      );
    }

    const { data: targetMember } = await admin
      .from("organization_members")
      .select("role")
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId)
      .maybeSingle();

    if (!targetMember) {
      return Response.json(
        { error: "No se encontró el miembro en la organización.", code: "USER_NOT_FOUND" },
        { status: 404, headers: corsHeaders }
      );
    }

    if (targetMember.role === "superadmin") {
      const { count } = await admin
        .from("organization_members")
        .select("*", { count: "exact", head: true })
        .eq("organization_id", payload.organizationId)
        .eq("role", "superadmin");

      if ((count ?? 0) <= 1) {
        return Response.json(
          {
            error: "No es posible remover al único superadministrador de la organización.",
            code: "LAST_SUPERADMIN",
          },
          { status: 400, headers: corsHeaders }
        );
      }
    }

    if (isAdministrator && !["editor", "comercial"].includes(targetMember.role)) {
      return Response.json(
        { error: "No tienes permiso para remover administradores o superadministradores.", code: "FORBIDDEN" },
        { status: 403, headers: corsHeaders }
      );
    }

    const orgProjects =
      (
        await admin
          .from("projects")
          .select("id")
          .eq("organization_id", payload.organizationId)
      ).data?.map((p) => p.id) ?? [];

    if (orgProjects.length > 0) {
      await admin
        .from("project_members")
        .delete()
        .eq("user_id", payload.userId)
        .in("project_id", orgProjects);
    }

    await admin
      .from("access_invitations")
      .delete()
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId);

    const { error: removeError } = await admin
      .from("organization_members")
      .delete()
      .eq("organization_id", payload.organizationId)
      .eq("user_id", payload.userId);

    if (removeError) {
      return Response.json(
        { error: "No fue posible retirar el acceso del usuario.", code: "REMOVE_ERROR" },
        { status: 500, headers: corsHeaders }
      );
    }

    await audit("team:remove_member", payload.userId, null, {
      removedRole: targetMember.role,
    });

    return Response.json({ status: "removed" }, { headers: corsHeaders });
  }

  // ==========================================
  // ACCIÓN 5: INVITAR NUEVO USUARIO
  // ==========================================
  if (action === "invite") {
    if (!payload.email || !payload.fullName || !payload.role) {
      return Response.json(
        {
          error: "Nombre, correo de trabajo y rol son obligatorios para invitar.",
          code: "MISSING_INVITE_FIELDS",
        },
        { status: 400, headers: corsHeaders }
      );
    }

    if (!VALID_ROLES.has(payload.role)) {
      return Response.json(
        { error: "El rol solicitado no es válido.", code: "INVALID_ROLE" },
        { status: 400, headers: corsHeaders }
      );
    }

    const projectIds = [...new Set(payload.projectIds ?? [])];
    const scopeError = ensureAdministratorScope(payload.role, projectIds);
    if (scopeError) {
      return Response.json(
        { error: scopeError, code: "SCOPE_VIOLATION" },
        { status: 403, headers: corsHeaders }
      );
    }

    const normalizedEmail = payload.email.trim().toLowerCase();

    // Validar si ya existe en la organización
    const { data: existingInvitation } = await admin
      .from("access_invitations")
      .select("user_id, accepted_at, expires_at")
      .eq("organization_id", payload.organizationId)
      .ilike("email", normalizedEmail)
      .maybeSingle();

    if (existingInvitation) {
      return Response.json(
        {
          status: existingInvitation.accepted_at ? "already_active" : "already_invited",
          userId: existingInvitation.user_id,
          expiresAt: existingInvitation.expires_at,
          message: existingInvitation.accepted_at
            ? "Este usuario ya activó su cuenta previamente."
            : "Ya existe una invitación pendiente para este correo.",
        },
        { headers: corsHeaders }
      );
    }

    // Invitar mediante Supabase Auth
    const { data: invited, error: inviteError } = await admin.auth.admin.inviteUserByEmail(
      normalizedEmail,
      {
        data: { full_name: payload.fullName.trim() },
        redirectTo: getInvitationRedirectUrl(),
      }
    );

    if (inviteError || !invited.user) {
      if (inviteError?.message.toLowerCase().includes("already")) {
        return Response.json(
          { status: "already_active", error: "El usuario ya está registrado en el sistema." },
          { headers: corsHeaders }
        );
      }
      return Response.json(
        { error: inviteError?.message ?? "Error al enviar la invitación.", code: "AUTH_INVITE_FAILED" },
        { status: 400, headers: corsHeaders }
      );
    }

    const newUserId = invited.user.id;

    // Actualizar o crear perfil de usuario con nombre
    await admin.from("profiles").upsert({
      id: newUserId,
      full_name: payload.fullName.trim(),
    });

    // Asignar rol en organization_members
    await admin.from("organization_members").upsert({
      organization_id: payload.organizationId,
      user_id: newUserId,
      role: payload.role,
    });

    // Asignar proyectos si corresponde
    if (payload.role !== "superadmin" && projectIds.length > 0) {
      const rows = projectIds.map((projectId) => ({
        project_id: projectId,
        user_id: newUserId,
        role:
          payload.role === "administrador"
            ? "manager"
            : payload.role === "editor"
              ? "editor"
              : "viewer",
      }));
      await admin.from("project_members").upsert(rows);
    }

    // Registrar en access_invitations
    const sentAt = new Date();
    const expiresAt = new Date(sentAt.getTime() + 60 * 60 * 1000).toISOString();

    await admin.from("access_invitations").upsert({
      organization_id: payload.organizationId,
      user_id: newUserId,
      email: normalizedEmail,
      sent_at: sentAt.toISOString(),
      expires_at: expiresAt,
      accepted_at: invited.user.email_confirmed_at,
      updated_at: sentAt.toISOString(),
    });

    await audit("team:invite_member", newUserId, projectIds[0] ?? null, {
      memberEmail: normalizedEmail,
      memberName: payload.fullName,
      role: payload.role,
      projectIds,
    });

    return Response.json(
      { userId: newUserId, status: "invited", expiresAt },
      { headers: corsHeaders }
    );
  }

  return Response.json(
    { error: "Acción no reconocida.", code: "UNKNOWN_ACTION" },
    { status: 400, headers: corsHeaders }
  );
});
