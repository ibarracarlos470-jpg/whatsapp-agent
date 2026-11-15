# RAILWAY DEPLOYMENT - SP360 EN VIVO (5 MINUTOS)

## PASO 1: Ir a Railway.app
1. Abre: https://railway.app
2. Click "Sign up" o "Log in" (usa GitHub para más rápido)

## PASO 2: Crear Nuevo Proyecto
1. Click "New Project"
2. Selecciona "Deploy from GitHub repo"
3. Conecta tu cuenta GitHub si no está conectada
4. Busca y selecciona: `ibarracarlos470-jpg/whatsapp-agent`

## PASO 3: Railway Detectará Node.js Automáticamente
- ✅ Verá `package.json` 
- ✅ Verá `Dockerfile` y `render.yaml`
- ✅ Detectará Node.js como runtime

## PASO 4: Configurar Variables de Entorno
Railway mostrará un formulario. Agrega estas variables:

```
GEMINI_API_KEY: AQ.Ab8RN6I592w8SiaxYQj4uTcNhu66_5-MdBdOU0Oa0zJTb8kZBg
WHATSAPP_API_TOKEN: EAAepZB3wn6wIBS2Lov8G2EYGGXzAJi53IZAguJghAYRKEtSYapRnofF0bk5tL6YcttGZBkW7mKZCEEOiFsAdMpd2VZBOYdfmCNbflxsyFcr2fC7ZA12CVhZBwXOMJGaGT9PYsZAZBRO6ZBYzbrRXyBwAdkg0yeRRGHPyYjpwn862GGBhNAmzBL6Gz8VPFLjUrh9biQifgyb8cSc9KZC8MATvHZBLpwWr2RsonDMeeZAb39wFH5xHlEDcO1UZALDyZCJAABXqQQikGDtWtYMVj3ZCjsuM2siYZBQZDZD
JWT_SECRET: your_jwt_secret_here
META_VERIFY_TOKEN: e24e347dcb0a98b4e98a95a467718248
PORT: 3000
NODE_ENV: production
```

## PASO 5: Deploy
1. Railway mostrará preview de deployment
2. Click "Deploy"
3. Espera 2-3 minutos

## PASO 6: Obtener URL
- Cuando termine, verás la URL en format: `https://<nombre>-production-xxxx.railway.app`
- Haz click en "View" para abrir la aplicación
- ✅ Deberías ver la página de login SP360

## PASO 7: Verificar
- GET `https://<tu-url>/health` → debe devolver `{ status: 'healthy', message: 'SP360 WhatsApp Agent running' }`
- GET `https://<tu-url>/` → debe devolver HTML con página de login SP360

---

## ¿PROBLEMAS?

### Si dice "Node.js not found":
- Railway a veces necesita un `Procfile` explícito. Aquí está:
```
web: node src/index.js
```
Agrégalo a la raíz, commit y push.

### Si dice "Port not available":
- Railway usa PORT automáticamente. No hay problema, funciona igual.

### Si no ve tus cambios:
- En Railway dashboard: "Rebuild" → fuerza nuevo build

---

## INFORMACIÓN PARA COPIAR

**Repositorio:** https://github.com/ibarracarlos470-jpg/whatsapp-agent
**Branch:** main
**Puerto:** 3000
**Dockerfile:** ✅ Incluido
**render.yaml:** ✅ Incluido (también es válido para Railway como referencia)

---

**TIEMPO TOTAL:** 5 minutos desde cero a en vivo.
