# node-pos

![Node.js](https://img.shields.io/badge/Node.js-%3E%3D20-339933?logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?logo=typescript&logoColor=white)
![Express](https://img.shields.io/badge/Express-5.x-000000?logo=express&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-7.x-2D3748?logo=prisma&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%2B-4169E1?logo=postgresql&logoColor=white)
![Licencia](https://img.shields.io/badge/licencia-GPLv3-blue)

API backend para un sistema de punto de venta (POS), construida con Node.js, Express y TypeScript. El proyecto centraliza la autenticación, autorización por roles y permisos, gestión de catálogo, compras, ventas, caja e inventario sobre PostgreSQL.

> Este repositorio contiene actualmente el backend de la solución. No incluye una aplicación frontend independiente.

## Características principales

- Autenticación de usuarios mediante JWT.
- Control de acceso basado en roles y permisos (RBAC).
- Gestión de usuarios, roles y permisos.
- Administración de categorías, productos, precios y existencias.
- Gestión de clientes, proveedores y tipos de documento.
- Flujo de órdenes y recepciones de compra.
- Registro de ventas y medios de pago.
- Apertura y cierre de caja.
- Ajustes de stock y trazabilidad mediante kardex.
- Carga y gestión de imágenes con Cloudinary.
- Validación de datos con Zod.
- Documentación interactiva de la API con Swagger UI en `/doc`.
- Migraciones y cliente de base de datos gestionados con Prisma.
- Configuración para desarrollo local con Docker Compose, PostgreSQL y pgAdmin.

## Tech stack

| Capa | Tecnologías |
| --- | --- |
| Backend | Node.js, Express 5, TypeScript |
| Persistencia | Prisma ORM, PostgreSQL 15+ |
| Seguridad | JSON Web Tokens (JWT), bcryptjs, RBAC |
| Validación y API | Zod, Swagger UI, swagger-jsdoc, CORS |
| Archivos multimedia | Cloudinary |
| Desarrollo | pnpm, ts-node-dev, Docker Compose |
| Frontend | No incluido en este repositorio |

## Prerrequisitos

- Node.js 20 o superior.
- pnpm 10.28.0 o compatible. También se pueden usar los scripts con npm.
- PostgreSQL 15 o superior, local o mediante Docker.
- Una cuenta de Cloudinary si se utilizarán cargas de imágenes.
- Git.

## Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd node-pos
```

### 2. Instalar dependencias

Con pnpm:

```bash
pnpm install
```

Con npm:

```bash
npm install
```

### 3. Configurar las variables de entorno

Copia la plantilla incluida en el repositorio:

```bash
cp .env.example .env
```

Completa `.env` con los valores de tu entorno. Como mínimo, la aplicación requiere:

```dotenv
NODE_ENV=development
PORT=3000
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/node_pos?schema=public"
JWT_SECRET="cambia-esta-clave-por-una-segura"
CLOUDINARY_CLOUD_NAME=""
CLOUDINARY_API_KEY=""
CLOUDINARY_API_SECRET=""
CLOUDINARY_UPLOAD_FOLDER="node-pos"
```

Si utilizas `docker-compose.dev.yml`, completa también `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `PGADMIN_DEFAULT_EMAIL` y `PGADMIN_DEFAULT_PASSWORD`. La URL de conexión debe coincidir con esas credenciales y con el nombre de la base de datos.

### 4. Iniciar PostgreSQL en desarrollo

```bash
docker compose -f docker-compose.dev.yml up -d
```

pgAdmin quedará disponible en `http://localhost:8080` con las credenciales definidas en `.env`.

### 5. Aplicar migraciones y cargar datos iniciales

```bash
pnpm exec prisma migrate deploy
pnpm run seed
```

Para npm, utiliza `npx prisma migrate deploy` y `npm run seed`.

### 6. Ejecutar la API

Modo desarrollo con recarga automática:

```bash
pnpm run dev
```

O con npm:

```bash
npm run dev
```

La API estará disponible en `http://localhost:3000` o en el puerto configurado en `PORT`. La documentación Swagger está en `http://localhost:3000/doc`.

## Scripts disponibles

| Script | Descripción |
| --- | --- |
| `pnpm run dev` | Inicia el servidor en desarrollo con recarga automática. |
| `pnpm run build` | Limpia `dist/` y compila TypeScript. |
| `pnpm start` | Compila el proyecto y ejecuta la versión generada. |
| `pnpm run seed` | Ejecuta el proceso de datos iniciales. |

## Estructura del proyecto

```text
node-pos/
├── prisma/
│   ├── migrations/       # Migraciones de PostgreSQL
│   └── schema.prisma     # Modelo de datos Prisma
├── src/
│   ├── app.ts            # Punto de entrada de la aplicación
│   ├── config/           # Variables de entorno, Prisma y Swagger
│   ├── doc/              # Esquemas de documentación de la API
│   ├── generated/        # Cliente Prisma generado
│   ├── middlewares/      # JWT, permisos y manejo de errores
│   ├── modules/          # Módulos por dominio funcional
│   ├── seed/             # Datos iniciales
│   ├── server/           # Servidor Express y rutas principales
│   ├── shared/           # Adaptadores y utilidades compartidas
│   └── utils/             # Utilidades generales
├── docker-compose.dev.yml
├── package.json
├── prisma.config.ts
└── tsconfig.json
```

Los módulos principales se encuentran en `src/modules/`: `auth`, `user`, `rol`, `permission`, `category`, `product`, `customer`, `supplier`, `payment`, `order-purchase`, `receipt-purchase`, `sale`, `box-open`, `box-closed` y `stock-adjustment`.

## API

Las rutas se organizan por recurso, por ejemplo:

- `/auth`: registro y autenticación.
- `/user`, `/rol`, `/permission`: administración de acceso.
- `/product`, `/category`: catálogo e inventario.
- `/customer`, `/supplier`: terceros comerciales.
- `/sale`, `/payment`: ventas y pagos.
- `/order-purchase`, `/receipt-purchase`: compras.
- `/box-open`, `/box-closed`: operaciones de caja.

Consulta la especificación completa y prueba los endpoints desde Swagger UI en `/doc`.

## Contribución

1. Crea una rama descriptiva para tu cambio.
2. Mantén la organización modular y los tipos estrictos del proyecto.
3. Ejecuta la compilación y las pruebas antes de abrir un pull request.
4. Describe el cambio, su motivación y cualquier migración requerida.

## Licencia

Este proyecto se distribuye bajo la **GNU General Public License v3.0 (GPLv3)**.

Es software libre y de código abierto. Cualquier modificación o trabajo derivado debe mantenerse bajo la misma licencia GPLv3 y publicar su código fuente de manera accesible, conforme a los términos de la licencia. Consulta [LICENSE.md](LICENSE.md) para más información.
