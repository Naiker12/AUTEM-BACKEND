# Login, permisos y despliegue

## Decisión de arquitectura

**Ahora:** Supabase Cloud: Auth, Postgres, RLS, Storage privado y Edge Functions
en TypeScript. No hay servidor Node ni Docker ejecutándose en este equipo.

**Más adelante:** añadir un servicio Fastify con TypeScript en Railway solo si
aparecen procesos largos, integraciones con conexiones persistentes, colas o
webhooks complejos. Railway no reemplaza Supabase: consume el JWT, verifica sus
claims y usa una clave secreta exclusivamente en variables del servicio.

## Modelo de acceso

Autenticación y autorización son capas distintas:

| Capa | Responsabilidad |
| --- | --- |
| Supabase Auth | Email, contraseña, recuperación, invitación y sesión JWT. |
| `profiles` | Nombre y avatar del usuario. |
| `organization_members` | Rol de organización: `superadmin`, `administrador`, `editor` o `comercial`. |
| `project_members` | Alcance por proyecto: `manager`, `editor` o `viewer`. |
| RLS | La decisión final para cada fila y archivo. La interfaz no otorga permisos. |

Todos son usuarios autenticados. El rol es una propiedad de su membresía, no un
campo editable desde el navegador. Superadministrador administra equipo y roles;
administrador administra proyectos; editor gestiona contenido de sus proyectos;
comercial consulta lo asignado.

## Flujo de login

1. El navegador llama `signInWithPassword` de `@supabase/supabase-js` con URL y
   clave **publicable**.
2. Supabase Auth valida identidad y emite/refresca una sesión JWT.
3. Las consultas llevan el JWT automáticamente; Postgres ejecuta grants y RLS.
4. RLS usa `auth.uid()` y las membresías para limitar organización, proyectos y
   archivos privados. El frontend solo adapta la experiencia a los permisos.
5. Para invitar, un superadministrador llama la Edge Function `invite-user`; la
   función valida al solicitante antes de usar la API administrativa de Auth.

## Claves y secretos

| Ubicación | Qué puede contener | Nunca contiene |
| --- | --- | --- |
| `D:\AUTEM\.env.local` | `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY` | `service_role`, contraseñas, tokens privados |
| `D:\AUTEM-BACKEND\supabase\.env` | `PUBLIC_SITE_URL` para Edge Functions | Claves `SUPABASE_*` administradas por Cloud |
| Supabase Dashboard / Secrets | SMTP, webhooks y secretos de integraciones | Valores enviados al navegador |
| Railway futuro | URL de Supabase, clave secreta si es imprescindible | Secretos en Git o en el cliente |

## Puesta en marcha segura

1. Crear `staging` y producción en Supabase Cloud, con proyectos separados.
2. Enlazar primero `staging`, ejecutar `pnpm db:push:dry` y revisar el SQL.
3. Ejecutar `pnpm db:push` y `pnpm functions:deploy`.
4. Configurar SMTP, URL de sitio y Redirect URLs de invitación/recuperación en
   Auth antes de invitar usuarios reales.
5. Crear el primer superadministrador mediante un procedimiento administrativo
   controlado; nunca permitir autoasignación desde el cliente.
6. Probar decisiones permitidas y denegadas de RLS. Cuando se habilite Docker o
   CI, usar `pnpm db:test` antes de cada despliegue.

## Convención de archivos

Los objetos privados de `project-media` y `project-360` deben tener esta ruta:

```text
<project-id-uuid>/<recurso>/<archivo>
```

La política de Storage extrae el UUID de la primera carpeta y valida acceso al
proyecto. Un archivo fuera de esa convención queda inaccesible.

## Despliegue futuro en Railway

No se crea servicio Railway hoy. Si se necesita, el servicio debe ser Node.js +
TypeScript + Fastify, desplegado desde GitHub con variables configuradas en
Railway. No requiere Dockerfile al inicio: Railway puede construir un proyecto
Node automáticamente. Solo se añadirá Dockerfile cuando el despliegue necesite
una imagen reproducible o dependencias del sistema específicas.
