# 🚀 Guía de Instalación - WhatsApp Agent

## Requisitos Previos

Asegúrate de tener instalados:

1. **Node.js** (v18+)
   - Descarga desde: https://nodejs.org/
   - Verifica: `node --version` y `npm --version`

2. **PostgreSQL** (v12+)
   - Descarga desde: https://www.postgresql.org/download/
   - Verifica que esté corriendo

3. **Redis** (opcional, para colas)
   - Descarga desde: https://redis.io/download

---

## Paso 1: Instalar Dependencias

Abre una terminal en `C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent` y ejecuta:

```bash
npm install
```

Esto puede tardar 2-5 minutos. Debería ver muchas líneas de instalación.

---

## Paso 2: Configurar Variables de Entorno

### a) Copia el archivo de ejemplo
```bash
copy .env.example .env
```

O simplemente copia manualmente:
1. Abre `.env.example`
2. Guarda como `.env` en la misma carpeta

### b) Edita `.env` con tus credenciales

```env
# Database (ajusta según tu config local)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=whatsapp_agent
DB_USER=postgres
DB_PASSWORD=tu_password_postgres

# Meta APIs - OBTÉN ESTOS EN PASO 3
WHATSAPP_API_TOKEN=abc123...
WHATSAPP_PHONE_NUMBER_ID=1234567890
META_VERIFY_TOKEN=mi_token_secreto

# Claude API - OBTÉN ESTO EN PASO 4
CLAUDE_API_KEY=sk-ant-...

# Redis
REDIS_URL=redis://localhost:6379

# Server
PORT=3000
NODE_ENV=development

# JWT
JWT_SECRET=tu_jwt_secret_super_secreto

# App
APP_NAME=WhatsApp Agent
APP_URL=http://localhost:3000
```

---

## Paso 3: Obtener Credenciales Meta (WhatsApp)

### Crear Aplicación Meta

1. Ir a: https://developers.facebook.com/
2. Login con tu cuenta Meta
3. Crear nueva aplicación:
   - Nombre: "WhatsApp Agent"
   - Tipo: "Business"
4. Agregar producto: **WhatsApp Business**

### Obtener Tokens

1. En **WhatsApp > Comenzar**, crear cuenta de negocio
2. Ir a **WhatsApp > Configuración de API**
3. Copiar:
   - **Token de acceso permanente** → `WHATSAPP_API_TOKEN`
   - **ID de número de teléfono** → `WHATSAPP_PHONE_NUMBER_ID`

### Configurar Webhook

1. En **WhatsApp > Configuración > Webhooks**
2. Establecer:
   - **URL de llamada:** `https://tu-dominio.com/api/webhook`
   - **Token de verificación:** `mi_token_secreto` (valor de `META_VERIFY_TOKEN`)
3. Suscribirse a eventos: `messages`

---

## Paso 4: Obtener Claude API Key

1. Ir a: https://console.anthropic.com/
2. Crear cuenta o login
3. En **API Keys**, crear nueva clave
4. Copiar en `CLAUDE_API_KEY`

---

## Paso 5: Configurar PostgreSQL Localmente

### En Windows con PostgreSQL instalado:

```bash
# Abre PostgreSQL psql
# O desde Windows PowerShell:
psql -U postgres

# Dentro de psql, crea la base de datos:
CREATE DATABASE whatsapp_agent;

# Verifica:
\l

# Salir:
\q
```

---

## Paso 6: Iniciar el Servidor

### Modo Desarrollo (con auto-reload):
```bash
npm run dev
```

### Producción:
```bash
npm start
```

Deberías ver:
```
Server running on port 3000
Database connected successfully
Database synchronized
```

---

## Paso 7: Verificar Que Funciona

Abre navegador:
- http://localhost:3000/health

Deberías ver:
```json
{
  "status": "healthy",
  "message": "WhatsApp Agent is running"
}
```

---

## 🔧 Troubleshooting

### Error: "ENOENT: no such file or directory, open '.env'"
- Solución: Crea `.env` a partir de `.env.example`

### Error: "connect ECONNREFUSED 127.0.0.1:5432"
- Solución: PostgreSQL no está corriendo. Inicia PostgreSQL

### Error: "WHATSAPP_API_TOKEN is not defined"
- Solución: Falta completar credenciales en `.env`

### Error: "no such table: companies"
- Solución: Sequelize debería crear automáticamente. Reinicia el servidor

### Puerto 3000 ya está en uso
- Solución: Cambia `PORT=3001` en `.env`

---

## 📞 Próximo: Crear Empresas y Agentes

Una vez que el servidor esté corriendo, necesitamos:

1. **API de Administración** para:
   - Crear empresas
   - Crear agentes
   - Configurar webhooks

2. **Dashboard** para:
   - Ver conversaciones
   - Configurar respuestas

3. **Autenticación** para:
   - Login de empresas
   - API Keys por empresa

---

## ✅ Checklist

- [ ] Node.js instalado (`node --version`)
- [ ] PostgreSQL instalado y corriendo
- [ ] `.env` completado con credenciales
- [ ] `npm install` completado exitosamente
- [ ] Base de datos `whatsapp_agent` creada
- [ ] `npm run dev` funcionando
- [ ] `/health` responde correctamente

¡Una vez completes esto, avanzamos a Fase 2! 🚀
