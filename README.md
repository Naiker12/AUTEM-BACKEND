# AUTEM Backend

Base de Supabase Cloud para autenticación, acceso por rol y permisos por proyecto.

No se ejecuta Docker en este equipo. El flujo principal trabaja directamente con
un proyecto remoto de Supabase; Docker queda como una opción futura para pruebas
locales aisladas o CI.

## Arquitectura

- [Mapa de login y permisos](docs/login-y-permisos.html)
- [Decisiones y puesta en marcha](docs/LOGIN_Y_DESPLIEGUE.md)

## Primer enlace con Supabase Cloud

1. Crea dos proyectos: `staging` y `producción`.
2. En este directorio ejecuta `pnpm install` y `pnpm supabase:login`.
3. Enlaza primero *staging*: `pnpm supabase:link --project-ref <project-ref>`.
4. Copia `.env.example` a `supabase/.env` y define solo `PUBLIC_SITE_URL`.
5. Revisa cambios: `pnpm db:push:dry`.
6. Aplica migraciones: `pnpm db:push`.
7. Sube la función segura de invitación: `pnpm functions:deploy`.
8. Configura el redirect URL de invitaciones en Supabase Auth y el SMTP real.

Nunca pongas una `service_role`/clave secreta en `D:\AUTEM`. Las funciones Edge
reciben esa clave desde Supabase Cloud. El frontend solo usa la URL y una clave
publicable, con RLS activado.

## Docker futuro

Cuando haya espacio o se use CI: `pnpm supabase:start`, `pnpm db:reset` y
`pnpm db:test`. Estos comandos no son necesarios para el despliegue Cloud.

## Estructura

- `supabase/migrations`: esquema y políticas RLS.
- `supabase/seed.sql`: organización y proyecto de desarrollo.
- `supabase/functions/invite-user`: invitación segura de usuarios.
