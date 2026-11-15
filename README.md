# WhatsApp Agent - Multi-Platform Customer Support AI

Agente inteligente de atención al cliente para WhatsApp, Instagram y Facebook, impulsado por Claude AI.

## 🎯 Características

- ✅ Integración con WhatsApp Business API
- ✅ Soporte para Instagram Direct Messages
- ✅ Soporte para Facebook Messenger
- ✅ Respuestas inteligentes con Claude AI
- ✅ Multi-tenant (múltiples empresas)
- ✅ Historial de conversaciones
- ✅ Dashboard de administración
- ✅ Configuración personalizada por empresa

## 📋 Requisitos

- Node.js 18+
- PostgreSQL 12+
- Redis 6+ (para colas)
- Cuenta de Meta Platforms (WhatsApp Business Account)
- Clave API de Claude

## 🚀 Instalación

### 1. Clonar el proyecto
```bash
git clone <repo-url>
cd whatsapp-agent
```

### 2. Instalar dependencias
```bash
npm install
```

### 3. Configurar variables de entorno
```bash
cp .env.example .env
```

Edita `.env` con tus credenciales:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=whatsapp_agent
DB_USER=postgres
DB_PASSWORD=your_password

# Meta APIs
WHATSAPP_API_TOKEN=your_whatsapp_token
WHATSAPP_PHONE_NUMBER_ID=your_phone_id
META_VERIFY_TOKEN=your_verify_token

# Claude API
CLAUDE_API_KEY=your_claude_key

# Server
PORT=3000
NODE_ENV=development
```

### 4. Crear base de datos
```bash
createdb whatsapp_agent
```

### 5. Ejecutar migraciones
```bash
npm run db:migrate
```

### 6. Iniciar servidor
```bash
npm start
```

Para desarrollo con recarga automática:
```bash
npm run dev
```

## 🔗 Integración Meta Webhook

### 1. Verificar webhook en Meta Platforms Business Manager

En tu configuración de webhook:

**URL de verificación:**
```
https://tu-dominio.com/api/webhook
```

**Token de verificación:** (el que pusiste en `META_VERIFY_TOKEN`)

### 2. Subscribe a eventos

- `message_template_status_update`
- `messages`
- `message_template_quality_update`

## 📚 Endpoints API

### Webhook (Recibir mensajes)
- `GET /api/webhook` - Verificar webhook
- `POST /api/webhook` - Recibir mensajes entrantes

### Status
- `GET /health` - Verificar salud del servidor

## 🏗️ Arquitectura

```
┌─────────────────┐
│   Meta APIs     │
│ (WA, IG, FB)    │
└────────┬────────┘
         │
    ┌────▼─────────────────┐
    │   Express Server     │
    │   Webhook Handler    │
    └────┬─────────────────┘
         │
    ┌────▼──────────┐  ┌──────────────┐
    │ Claude AI     │  │  PostgreSQL  │
    │ Responses     │  │  Conversations│
    └───────────────┘  └──────────────┘
```

## 🛠️ Desarrollo

### Estructura de carpetas

```
src/
├── config/          # Configuración
├── models/          # Modelos Sequelize
├── routes/          # Rutas Express
├── controllers/     # Controladores
├── services/        # Lógica de negocio
├── middleware/      # Middlewares
├── queues/          # Colas de trabajo
└── utils/           # Utilidades
```

### Modelos de datos

- **Company**: Empresas clientes
- **Agent**: Configuración del agente IA
- **Conversation**: Conversaciones con clientes
- **Message**: Mensajes individuales

## 📝 Licencia

MIT

## 🤝 Soporte

Para reportar bugs o sugerencias, abre un issue en GitHub.
