# 🚀 Cómo Iniciar el Servidor

## ⚠️ Requisito: PostgreSQL debe estar corriendo

### Paso 1: Iniciar PostgreSQL

**Opción A: Si lo instalaste normalmente**
```powershell
# Windows - Abre "Services" y busca "postgresql"
# O ejecuta esto en PowerShell como Admin:
net start postgresql-x64-15
```

**Opción B: Si está en programa**
- Búsqueda de Windows → "Services"
- Busca "postgresql"
- Haz clic derecho → "Start"

**Opción C: Verificar si está corriendo**
```powershell
netstat -an | findstr :5432
```

---

## Paso 2: Crear la Base de Datos

```powershell
# Abre PostgreSQL
psql -U postgres

# Dentro de psql:
CREATE DATABASE whatsapp_agent;

# Verificar:
\l

# Salir:
\q
```

---

## Paso 3: Iniciar el Servidor

```powershell
cd "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"
npm run dev
```

Deberías ver:
```
✓ Server running on port 3000
✓ Database connected successfully
✓ Database synchronized
```

---

## Paso 4: Verificar que funciona

Abre navegador:
```
http://localhost:3000/health
```

Deberías ver:
```json
{
  "status": "healthy",
  "message": "WhatsApp Agent is running"
}
```

---

## 🆘 Troubleshooting

### Error: "ConnectionRefusedError"
→ PostgreSQL no está corriendo. Inicia el servicio.

### Error: "database whatsapp_agent does not exist"
→ Crea la BD: `CREATE DATABASE whatsapp_agent;`

### Error: "Port 3000 already in use"
→ Cambia en `.env`: `PORT=3001`

### Error: "Gemini API error"
→ Verifica que GEMINI_API_KEY en .env sea correcto

---

¡Una vez que veas el servidor corriendo, continuamos! 🎉
