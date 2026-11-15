# 🚀 DEPLOY A HEROKU CON DOCKER

## ✅ Requisitos

- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) instalado
- [Docker](https://www.docker.com/products/docker-desktop) instalado
- Cuenta en [Heroku](https://www.heroku.com) (gratis)
- Git instalado

---

## 📋 PASO A PASO

### PASO 1: Login a Heroku

```bash
heroku login
# Se abrirá navegador para autenticar
```

### PASO 2: Crear Aplicación en Heroku

```bash
# Para el Backend
heroku create whatsapp-agent-backend-tuombre

# Para el Frontend
heroku create whatsapp-agent-frontend-tuombre

# O el CLI lo crea automáticamente
```

**Nota:** Reemplaza `tuombre` con tu nombre (ej: `whatsapp-agent-backend-marcelo`)

### PASO 3: Configurar Variables de Entorno

```bash
# En la app backend
heroku config:set -a whatsapp-agent-backend-tuombre \
  GEMINI_API_KEY=AQ.Ab8RN6I592w8... \
  WHATSAPP_API_TOKEN=EAAepZB3wn6w... \
  WHATSAPP_PHONE_NUMBER_ID=102234567890123 \
  META_VERIFY_TOKEN=e24e347dcb0a98b4e98a95a467718248 \
  JWT_SECRET=tu_jwt_secret_mega_seguro \
  APP_URL=https://whatsapp-agent-backend-tuombre.herokuapp.com
```

### PASO 4: Deploy Backend

```bash
cd C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent

# Crear archivo heroku.yml
echo "build:
  docker:
    web: Dockerfile" > heroku.yml

# Deploy
git init
git add .
git commit -m "Initial commit - WhatsApp Agent"
git push heroku main
```

**Si hay error de rama:**
```bash
git push heroku HEAD:main
```

### PASO 5: Deploy Frontend

```bash
cd frontend

# Crear heroku.yml
echo "build:
  docker:
    web: Dockerfile" > heroku.yml

# Setup git (si no existe)
git init
git add .
git commit -m "Frontend - React Vite"
git push heroku main
```

### PASO 6: Verificar Deploy

```bash
# Ver logs del backend
heroku logs -a whatsapp-agent-backend-tuombre --tail

# Ver logs del frontend
heroku logs -a whatsapp-agent-frontend-tuombre --tail

# Abrir en navegador
heroku open -a whatsapp-agent-frontend-tuombre
```

---

## 🔗 URLs Finales

```
Backend:  https://whatsapp-agent-backend-tuombre.herokuapp.com
Frontend: https://whatsapp-agent-frontend-tuombre.herokuapp.com
Health:   https://whatsapp-agent-backend-tuombre.herokuapp.com/health
```

---

## 🔧 Configurar API Frontend

Después del deploy, actualiza la URL de API:

**Frontend `.env` (en Heroku):**
```
VITE_API_URL=https://whatsapp-agent-backend-tuombre.herokuapp.com
```

O edita directamente en `frontend/src/pages/LoginPage.jsx`:
```javascript
const API_URL = 'https://whatsapp-agent-backend-tuombre.herokuapp.com/api';
```

---

## 🌍 Configurar Webhook en Meta (WhatsApp)

1. Ve a: https://developers.facebook.com/
2. En tu app WhatsApp → Configuración → Webhooks
3. Actualiza:
   - **URL:** `https://whatsapp-agent-backend-tuombre.herokuapp.com/api/webhook`
   - **Token:** `e24e347dcb0a98b4e98a95a467718248`

---

## ⚠️ PROBLEMAS COMUNES

### Error: "Cannot find module"
```bash
# Reinstalar dependencias
heroku run npm install -a whatsapp-agent-backend-tuombre
```

### BD SQLite vacía
```bash
# La BD se crea automáticamente en primer start
# Pero si necesitas resetear:
heroku run "rm database/whatsapp_agent.db" -a whatsapp-agent-backend-tuombre
heroku restart -a whatsapp-agent-backend-tuombre
```

### CORS error
Agregar en backend `src/index.js`:
```javascript
app.use(cors({
  origin: ['https://whatsapp-agent-frontend-tuombre.herokuapp.com'],
  credentials: true
}));
```

### Port binding error
Heroku asigna `process.env.PORT`. Verificar que esté en `.env`:
```
PORT=3000
```

---

## 📊 Monitorear en Producción

```bash
# Ver estado
heroku status -a whatsapp-agent-backend-tuombre

# Ver BD
heroku run "sqlite3 database/whatsapp_agent.db" -a whatsapp-agent-backend-tuombre

# Escalar dynos (si es necesario)
heroku ps:scale web=1 -a whatsapp-agent-backend-tuombre
```

---

## 💰 COSTO

- **Heroku Starter:** $5-7/mes por app
- **BD SQLite:** Gratis (pero limitado)
- **Dominio:** $10-15/año

---

## 🎯 SIGUIENTE

Una vez deployado:
1. ✅ Prueba el sitio en vivo
2. ✅ Configura webhook en Meta
3. ✅ Recibe primer mensaje
4. ✅ ¡A vender! 💰

---

## 📞 SOPORTE

Si tienes error, ejecuta:
```bash
heroku logs -a whatsapp-agent-backend-tuombre --tail
```

Copia el error y busca en:
- [Heroku Status](https://status.heroku.com/)
- [StackOverflow](https://stackoverflow.com/search?q=heroku+docker)
