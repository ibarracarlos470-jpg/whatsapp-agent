# 🔑 Guía: Obtener Tokens de Meta y Claude

---

## 1️⃣ TOKENS DE META (WhatsApp)

### Paso 1: Crear Cuenta de Desarrollador

1. Ve a: **https://developers.facebook.com/**
2. Haz clic en **"Comenzar"** (esquina superior derecha)
3. **Registrate** con tu cuenta personal de Facebook o crea una nueva
4. Completa el formulario (nombre, email, teléfono, empresa)

### Paso 2: Crear una Aplicación

1. En el dashboard, haz clic en **"Mis aplicaciones"** (arriba)
2. Haz clic en **"Crear aplicación"**
3. Elige tipo: **"Comercial"** (no "Consumidor")
4. Rellena:
   - **Nombre de la aplicación:** "WhatsApp Agent" (o el que quieras)
   - **Email de contacto:** tu email
   - Haz clic en **"Crear aplicación"**

### Paso 3: Agregar Producto WhatsApp

1. En tu app, ve a **"Mis productos"** (esquina superior izquierda)
2. Haz clic en el **"+"** para agregar producto
3. Busca **"WhatsApp"** 
4. Haz clic en **"Configurar"** en WhatsApp Business Platform
5. Completa el asistente (verifica tu negocio, etc.)

### Paso 4: Obtener los 3 Tokens

Dentro de WhatsApp > Configuración:

#### a) **WHATSAPP_API_TOKEN** (Token de acceso)
- Ve a **Configuración** → **Claves y tokens**
- Busca **"Token de acceso permanente"**
- Haz clic en **Generar token**
- **COPIA** todo el token (es largo, ~100+ caracteres)
- Pégalo en `.env` como:
  ```
  WHATSAPP_API_TOKEN=EAABkaBla123abc...
  ```

#### b) **WHATSAPP_PHONE_NUMBER_ID** (ID del número)
- Dentro de WhatsApp, ve a **Configuración** → **Números de teléfono**
- Verás tu número asignado (o solicita uno)
- Debajo del número, encontrarás **"ID del número de teléfono"**
- Es un número como: `102234567890123`
- Pégalo en `.env`:
  ```
  WHATSAPP_PHONE_NUMBER_ID=102234567890123
  ```

#### c) **META_VERIFY_TOKEN** (Token de verificación de webhook)
- Este LO CREAS TÚ (puede ser cualquier string)
- Ej: `my_super_secret_webhook_token_12345`
- Pégalo en `.env`:
  ```
  META_VERIFY_TOKEN=my_super_secret_webhook_token_12345
  ```

### Paso 5: Configurar Webhook en Meta (después)

Cuando tengas tu servidor corriendo:

1. En WhatsApp > **Configuración** → **Webhooks**
2. Haz clic en **Editar**
3. Rellena:
   - **URL de callback:** `https://tu-dominio.com/api/webhook` (cambiar por tu dominio)
   - **Token de verificación:** el valor que pusiste en `META_VERIFY_TOKEN`
4. Eventos: Marca ✓ **messages**
5. Haz clic en **Verificar y guardar**

---

## 2️⃣ CLAUDE API KEY

### Paso 1: Ir a Anthropic Console

1. Ve a: **https://console.anthropic.com/**
2. Si no tienes cuenta, haz clic en **Sign Up**
3. Completa el formulario con email/contraseña

### Paso 2: Crear API Key

1. En el dashboard, ve a **Settings** (izquierda)
2. Haz clic en **API Keys** (o ve a: https://console.anthropic.com/account/keys)
3. Haz clic en **Create Key**
4. Dale nombre: "WhatsApp Agent" (opcional)
5. **COPIA** la clave (aparece una sola vez)

**⚠️ IMPORTANTE:** Cópiala ahora mismo. No aparecerá de nuevo.

### Paso 3: Guardar en .env

```env
CLAUDE_API_KEY=sk-ant-abc123xyz789...
```

---

## ✅ Checklist: ¿Tienes todos?

- [ ] WHATSAPP_API_TOKEN (empieza con "EAA" o similar)
- [ ] WHATSAPP_PHONE_NUMBER_ID (número largo como 102234567890123)
- [ ] META_VERIFY_TOKEN (string que creaste tú)
- [ ] CLAUDE_API_KEY (empieza con "sk-ant-")

---

## 📝 Tu .env completado debe verse así:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=whatsapp_agent
DB_USER=postgres
DB_PASSWORD=      # dejar en blanco si no tienes contraseña

# Meta APIs
WHATSAPP_API_TOKEN=EAAbla123abc...
WHATSAPP_PHONE_NUMBER_ID=102234567890123
META_VERIFY_TOKEN=my_super_secret_webhook_token_12345

# Claude API
CLAUDE_API_KEY=sk-ant-abc123xyz789...

# Redis
REDIS_URL=redis://localhost:6379

# Server
PORT=3000
NODE_ENV=development

# JWT
JWT_SECRET=mi_jwt_secret_super_seguro

# App
APP_NAME=WhatsApp Agent
APP_URL=http://localhost:3000
```

---

## 🚨 NOTAS DE SEGURIDAD

1. **NUNCA** compartas estos tokens
2. **NUNCA** los commits a Git (ya están en .gitignore)
3. Si accidentalmente los expones públicamente, **REGENERALOS** inmediatamente
4. Usa variables de entorno en producción, NUNCA hardcodea tokens

---

## 💰 Costos

- **Meta WhatsApp API:** 
  - Pruebas: Gratis (primeros 1000 mensajes/mes)
  - Producción: $0.0079 por mensaje entrante
  
- **Claude API:**
  - Pago por uso (facturación mensual)
  - Aproximado: $0.01 por 1000 tokens

---

## 🆘 Problemas Comunes

### "Token inválido"
- Verifica que copiaste TODO el token (sin espacios)
- No cambies nada del token después de copiarlo

### "Webhook no se verifica"
- Asegúrate que:
  - Tu URL es HTTPS (no HTTP)
  - Tu servidor está corriendo (`npm run dev`)
  - El META_VERIFY_TOKEN en .env es idéntico al que pusiste en Meta

### "API Key de Claude no funciona"
- Verifica que empiece con `sk-ant-`
- Que NO haya espacios extras
- Que sea de la región correcta

---

## 📞 Soporte Oficial

- **Meta Developers:** https://developers.facebook.com/support
- **Anthropic Help:** https://support.anthropic.com/
- **WhatsApp Business API Docs:** https://developers.facebook.com/docs/whatsapp/cloud-api

---

Una vez que tengas los 4 tokens en `.env`, ¡avísame para iniciar el servidor! 🚀
