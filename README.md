# AUTEM Backend

## Fase 1 · Login y acceso al panel

Esta fase prepara el acceso seguro al panel de AUTEM con Supabase Cloud. Incluye
login por email y contraseña, recuperación de acceso, invitación de usuarios y
permisos por organización y proyecto.

## Cómo funciona

1. La persona inicia sesión en el panel con email y contraseña.
2. Supabase Auth valida la identidad y crea su sesión.
3. El panel consulta los datos usando esa sesión.
4. Postgres + RLS comprueban el rol y los proyectos asignados antes de devolver
   cualquier información.
5. Un superadministrador invita nuevas personas desde el panel; la función
   `invite-user` valida su permiso antes de crear la invitación y asignaciones.

La interfaz puede ocultar acciones que no correspondan, pero la decisión real
siempre la toma la base de datos mediante RLS.

## Roles

| Rol | Puede hacer |
| --- | --- |
| **Superadministrador** | Gestionar equipo, invitaciones, roles, organización y todos los proyectos. |
| **Administrador** | Gestionar proyectos y contenido de la organización, sin cambiar roles del equipo. |
| **Editor** | Editar contenido únicamente en los proyectos asignados. |
| **Comercial** | Consultar información de los proyectos asignados. |

Cada persona es un usuario autenticado. Su rol pertenece a la organización y
puede complementarse con una asignación concreta por proyecto:
`manager`, `editor` o `viewer`.

## Información que se guarda

- `auth.users`: identidad y sesión, administradas por Supabase Auth.
- `profiles`: nombre y avatar.
- `organization_members`: rol dentro de AUTEM.
- `projects` y `project_members`: proyectos y su alcance por persona.
- Storage privado: imágenes, PDFs, videos y recursos 360 por proyecto.

Los archivos privados deben usar esta estructura:

```text
<project-id-uuid>/<recurso>/<archivo>
```

## Claves

En `D:\AUTEM\.env.local` solo van valores públicos:

```env
VITE_SUPABASE_URL=https://<project-ref>.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_<tu-clave-publica>
```

Nunca se suben al repositorio ni se usan en el navegador claves secretas,
`service_role`, contraseñas o tokens privados.

## Antes de activar usuarios reales

1. Crear el proyecto de Supabase Cloud de *staging*.
2. Enlazarlo con `pnpm supabase:link --project-ref <project-ref>`.
3. Revisar la migración con `pnpm db:push:dry`.
4. Aplicarla con `pnpm db:push`.
5. Desplegar invitaciones con `pnpm functions:deploy`.
6. Configurar SMTP y las URLs de redirección de login, recuperación e invitación
   en Supabase Auth.
7. Crear el primer superadministrador de forma controlada.

## Estructura

- `supabase/migrations`: modelo de datos y políticas RLS.
- `supabase/functions/invite-user`: invitación segura de personas.
- `docs/login-y-permisos.html`: diagrama visual del flujo.
- `docs/LOGIN_Y_DESPLIEGUE.md`: decisiones técnicas ampliadas.
