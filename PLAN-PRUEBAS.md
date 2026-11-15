# 🧪 PLAN DE PRUEBAS END-TO-END

## ✅ CHECKLIST DE PRUEBAS

---

## PARTE 1: BACKEND API (cURL/Postman)

### 1.1 Verificar Servidor
```bash
curl http://localhost:3000/health
```

**Resultado esperado:**
```json
{
  "status": "healthy",
  "message": "WhatsApp Agent is running"
}
```
**Status:** ⏳ Por probar

---

### 1.2 Registrar Empresa
```bash
curl -X POST http://localhost:3000/api/companies/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Tech Solutions Inc",
    "email": "admin@techsolutions.com",
    "industry": "Servicios",
    "whatsappPhoneNumber": "1234567890"
  }'
```

**Resultado esperado:**
```json
{
  "success": true,
  "company": {
    "id": "uuid-aqui",
    "name": "Tech Solutions Inc",
    "email": "admin@techsolutions.com",
    "apiKey": "uuid-key"
  },
  "token": "jwt-token-aqui"
}
```

**Guardar:** El `token` para las próximas pruebas

**Status:** ⏳ Por probar

---

### 1.3 Obtener Perfil Empresa
```bash
curl http://localhost:3000/api/companies/profile \
  -H "Authorization: Bearer <TOKEN>"
```

**Resultado esperado:**
```json
{
  "id": "uuid",
  "name": "Tech Solutions Inc",
  "email": "admin@techsolutions.com",
  "industry": "Servicios",
  "plan": "starter",
  "Agents": []
}
```

**Status:** ⏳ Por probar

---

### 1.4 Crear Agente
```bash
curl -X POST http://localhost:3000/api/agents \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Agente de Soporte",
    "systemPrompt": "Eres un asistente técnico profesional. Ayudas a clientes con problemas de software.",
    "temperature": 0.7,
    "personality": {
      "tone": "professional",
      "language": "es"
    }
  }'
```

**Resultado esperado:**
```json
{
  "success": true,
  "agent": {
    "id": "agent-uuid",
    "companyId": "company-uuid",
    "name": "Agente de Soporte",
    "systemPrompt": "...",
    "isActive": true,
    "temperature": 0.7,
    "createdAt": "2024-11-15T..."
  }
}
```

**Guardar:** El `id` del agente

**Status:** ⏳ Por probar

---

### 1.5 Listar Agentes
```bash
curl http://localhost:3000/api/agents \
  -H "Authorization: Bearer <TOKEN>"
```

**Resultado esperado:**
```json
[
  {
    "id": "agent-uuid",
    "companyId": "company-uuid",
    "name": "Agente de Soporte",
    "isActive": true,
    "temperature": 0.7
  }
]
```

**Status:** ⏳ Por probar

---

### 1.6 Estadísticas Empresa
```bash
curl http://localhost:3000/api/companies/stats \
  -H "Authorization: Bearer <TOKEN>"
```

**Resultado esperado:**
```json
{
  "company": "Tech Solutions Inc",
  "plan": "starter",
  "conversations": 0,
  "messages": 0,
  "agentsActive": 1
}
```

**Status:** ⏳ Por probar

---

## PARTE 2: FRONTEND (Browser)

### 2.1 Acceder a la App
```
http://localhost:5173
```

**Esperado:** Página de login/registro
**Status:** ⏳ Por probar

---

### 2.2 Registrar Empresa en UI
1. Click en "Registrate aquí"
2. Llenar:
   - Nombre: `Tech Solutions Inc`
   - Email: `admin@techsolutions.com`
   - Industria: `Servicios`
3. Click "Registrarse"

**Esperado:** Redirige a Dashboard
**Status:** ⏳ Por probar

---

### 2.3 Ver Dashboard
**Esperado:**
- ✅ Muestre estadísticas (conversaciones, mensajes, agentes)
- ✅ Guía de inicio rápido
- ✅ Información del proyecto

**Status:** ⏳ Por probar

---

### 2.4 Ir a Sección Agentes
Click en navegación → "Agentes"

**Esperado:**
- ✅ Lista vacía (no hay agentes aún)
- ✅ Botón "➕ Crear Agente"

**Status:** ⏳ Por probar

---

### 2.5 Crear Agente desde UI
1. Click "➕ Crear Agente"
2. Llenar formulario:
   - Nombre: `Agente de Ventas`
   - Prompt: `Eres un vendedor profesional. Ayuda a clientes a encontrar productos.`
   - Temperatura: 0.7
3. Click "Crear Agente"

**Esperado:**
- ✅ Aparece en lista
- ✅ Muestra tarjeta con info
- ✅ Status "🟢 Activo"

**Status:** ⏳ Por probar

---

### 2.6 Ver Conversaciones
Click en navegación → "Conversaciones"

**Esperado:**
- ✅ Tabla de conversaciones
- ✅ Mensaje "No hay conversaciones aún"

**Status:** ⏳ Por probar

---

### 2.7 Logout
Click "Logout"

**Esperado:**
- ✅ Redirige a login
- ✅ Token removido de localStorage

**Status:** ⏳ Por probar

---

## PARTE 3: INTEGRACIÓN (Más Avanzado)

### 3.1 Webhook WhatsApp (simulado)
```bash
curl -X POST http://localhost:3000/api/webhook \
  -H "Content-Type: application/json" \
  -d '{
    "object": "whatsapp_business_account",
    "entry": [{
      "changes": [{
        "field": "messages",
        "value": {
          "messages": [{
            "from": "5491234567890",
            "id": "msg-123",
            "text": {"body": "Hola, quiero saber más"}
          }],
          "contacts": [{"profile": {"name": "Juan"}}],
          "metadata": {"phone_number_id": "1234567890"}
        }
      }]
    }]
  }'
```

**Esperado:**
- ✅ Procesa sin errores
- ✅ Crea conversación en BD

**Status:** ⏳ Por probar

---

## 📊 MATRIZ DE RESULTADOS

| # | Prueba | Resultado | Nota |
|---|--------|-----------|------|
| 1.1 | GET /health | ⏳ | |
| 1.2 | POST /register | ⏳ | |
| 1.3 | GET /profile | ⏳ | |
| 1.4 | POST /agents | ⏳ | |
| 1.5 | GET /agents | ⏳ | |
| 1.6 | GET /stats | ⏳ | |
| 2.1 | Acceder UI | ⏳ | |
| 2.2 | Registrar UI | ⏳ | |
| 2.3 | Dashboard | ⏳ | |
| 2.4 | Sección Agentes | ⏳ | |
| 2.5 | Crear Agente UI | ⏳ | |
| 2.6 | Ver Conversaciones | ⏳ | |
| 2.7 | Logout | ⏳ | |
| 3.1 | Webhook | ⏳ | |

---

## 🎯 INSTRUCCIONES

1. **Abre 2 terminales:**
   - Terminal 1: Backend (`npm run dev`)
   - Terminal 2: Frontend (`npm run dev`)

2. **Espera a que ambos inicien:**
   - Backend: "Server running on port 3000"
   - Frontend: "VITE v..." 

3. **Abre navegador:**
   - http://localhost:5173

4. **Sigue las pruebas en ORDEN**

5. **Marca ✅ cuando completes cada una**

6. **Reporta errores con captura de pantalla**

---

## 🐛 Si Algo Falla

### Backend error
```bash
cd backend
npm run dev
# Ver error en terminal
```

### Frontend error
```bash
cd frontend
npm run dev
# Ver error en terminal
```

### CORS error
Backend necesita agregar headers CORS. Verificar `/api/webhook`

### Token inválido
Registra nueva empresa, recibe nuevo token

---

## ✅ ÉXITO

Si TODAS las pruebas pasan: **PROYECTO FUNCIONA 100%**

Siguiente: Deploy en producción 🚀
