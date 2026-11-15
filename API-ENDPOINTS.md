# 📡 API Endpoints - WhatsApp Agent

## 🔐 Autenticación

Todos los endpoints (excepto `/register`) requieren un token JWT en el header:

```
Authorization: Bearer <token>
```

---

## 🏢 Empresas (Companies)

### 1. Registrar Empresa (Sin autenticación)
```
POST /api/companies/register
```

**Request:**
```json
{
  "name": "Mi Empresa",
  "email": "admin@empresa.com",
  "industry": "E-commerce",
  "whatsappPhoneNumber": "1234567890"
}
```

**Response:**
```json
{
  "success": true,
  "company": {
    "id": "uuid-here",
    "name": "Mi Empresa",
    "email": "admin@empresa.com",
    "apiKey": "uuid-here"
  },
  "token": "jwt-token-here"
}
```

---

### 2. Obtener Perfil de Empresa
```
GET /api/companies/profile
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": "uuid",
  "name": "Mi Empresa",
  "email": "admin@empresa.com",
  "industry": "E-commerce",
  "plan": "starter",
  "Agents": [
    {
      "id": "agent-uuid",
      "name": "Agente de Ventas",
      "isActive": true
    }
  ]
}
```

---

### 3. Actualizar Perfil de Empresa
```
PUT /api/companies/profile
```

**Request:**
```json
{
  "name": "Nueva Empresa",
  "industry": "Consultoría",
  "whatsappPhoneNumber": "9876543210",
  "instagramHandle": "@empresa",
  "facebookPageId": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "company": { ... }
}
```

---

### 4. Obtener Estadísticas
```
GET /api/companies/stats
```

**Response:**
```json
{
  "company": "Mi Empresa",
  "plan": "starter",
  "conversations": 42,
  "messages": 156,
  "agentsActive": 2
}
```

---

## 🤖 Agentes (Agents)

### 1. Crear Agente
```
POST /api/agents
```

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "name": "Agente de Ventas",
  "systemPrompt": "Eres un asistente de ventas amable. Ayuda a los clientes con preguntas sobre nuestros productos.",
  "personality": {
    "tone": "friendly",
    "language": "es"
  },
  "capabilities": {
    "answerQuestions": true,
    "scheduleMeetings": true,
    "processPayments": false
  },
  "temperature": 0.7
}
```

**Response:**
```json
{
  "success": true,
  "agent": {
    "id": "agent-uuid",
    "companyId": "company-uuid",
    "name": "Agente de Ventas",
    "systemPrompt": "...",
    "isActive": true,
    "createdAt": "2024-11-15T10:00:00Z"
  }
}
```

---

### 2. Listar Agentes
```
GET /api/agents
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": "agent-uuid-1",
    "name": "Agente de Ventas",
    "isActive": true,
    "temperature": 0.7
  },
  {
    "id": "agent-uuid-2",
    "name": "Soporte Técnico",
    "isActive": false,
    "temperature": 0.5
  }
]
```

---

### 3. Obtener Agente por ID
```
GET /api/agents/:agentId
```

**Response:**
```json
{
  "id": "agent-uuid",
  "name": "Agente de Ventas",
  "systemPrompt": "...",
  "personality": { "tone": "friendly", "language": "es" },
  "capabilities": { ... },
  "temperature": 0.7,
  "isActive": true
}
```

---

### 4. Actualizar Agente
```
PUT /api/agents/:agentId
```

**Request:**
```json
{
  "name": "Agente de Ventas Premium",
  "systemPrompt": "Eres un vendedor experto...",
  "temperature": 0.8,
  "isActive": true
}
```

**Response:**
```json
{
  "success": true,
  "agent": { ... }
}
```

---

### 5. Clonar Agente
```
POST /api/agents/:agentId/clone
```

**Request:**
```json
{
  "newName": "Agente de Ventas Copia"
}
```

**Response:**
```json
{
  "success": true,
  "agent": {
    "id": "new-agent-uuid",
    "name": "Agente de Ventas Copia",
    "isActive": false
  }
}
```

---

### 6. Eliminar Agente
```
DELETE /api/agents/:agentId
```

**Response:**
```json
{
  "success": true,
  "message": "Agent deleted"
}
```

---

## 🔗 Webhook (Recibir mensajes de WhatsApp)

### Verificar Webhook
```
GET /api/webhook?hub.mode=subscribe&hub.verify_token=...&hub.challenge=...
```

### Recibir Mensajes
```
POST /api/webhook
```

**Webhook Body (enviado por Meta):**
```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "changes": [
        {
          "field": "messages",
          "value": {
            "messages": [
              {
                "from": "5491234567890",
                "id": "msg-id",
                "text": { "body": "Hola, quiero comprar..." }
              }
            ],
            "contacts": [
              { "profile": { "name": "Juan" } }
            ],
            "metadata": {
              "phone_number_id": "123456789"
            }
          }
        }
      ]
    }
  ]
}
```

---

## 📊 Status
```
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "message": "WhatsApp Agent is running"
}
```

---

## 🆘 Códigos de Error

| Código | Significado |
|--------|------------|
| 200 | OK |
| 201 | Creado |
| 400 | Bad Request (datos inválidos) |
| 401 | No autorizado / Token inválido |
| 404 | No encontrado |
| 500 | Error del servidor |

---

## 💡 Ejemplos de Uso

### Registrar una empresa
```bash
curl -X POST http://localhost:3000/api/companies/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mi Tienda Online",
    "email": "admin@tienda.com",
    "industry": "E-commerce",
    "whatsappPhoneNumber": "1234567890"
  }'
```

### Crear un agente
```bash
curl -X POST http://localhost:3000/api/agents \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Atención al Cliente",
    "systemPrompt": "Eres un asistente amable...",
    "temperature": 0.7
  }'
```

### Listar agentes
```bash
curl -X GET http://localhost:3000/api/agents \
  -H "Authorization: Bearer <token>"
```

---

¡Usa estos endpoints desde Postman, Thunder Client, o desde tu frontend! 🚀
