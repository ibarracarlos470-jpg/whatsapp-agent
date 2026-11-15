# 🗄️ Configuración SQLite

## ¿Por qué SQLite?

| Aspecto | SQLite | PostgreSQL |
|--------|--------|------------|
| Instalación | ✅ Automática | ❌ Requiere instalación |
| Configuración | ✅ Cero configuración | ❌ Host, puerto, usuario |
| Desarrollo | ✅ Perfecto | ⚠️ Overkill |
| Producción | ⚠️ Limitado | ✅ Robusto |
| Archivo | ✅ `whatsapp_agent.db` | ❌ Servidor separado |

---

## ✅ Cambios Realizados

1. **Driver instalado:** `sqlite3` y `better-sqlite3`
2. **Configuración:** `src/config/database.js` → SQLite
3. **Almacenamiento:** `database/whatsapp_agent.db`
4. **Multi-tenant:** Funciona igual con SQLite

---

## 📂 Archivo de Base de Datos

La BD se almacena en:
```
whatsapp-agent/database/whatsapp_agent.db
```

**Tamaño típico:**
- Vacío: ~100KB
- Con 1000 conversaciones: ~5MB
- Con 10000 mensajes: ~20MB

---

## 🔄 Migrar a PostgreSQL (Producción)

Cuando estés listo para producción:

### 1. Instalar PostgreSQL en servidor
```bash
# En Linux/Windows con PostgreSQL instalado
createdb whatsapp_agent_prod
```

### 2. Actualizar `src/config/database.js`
```javascript
const sequelize = new Sequelize(
  'whatsapp_agent_prod',
  'postgres_user',
  'password',
  {
    host: 'prod-db-server.com',
    dialect: 'postgres',
  }
);
```

### 3. Sequelize sincroniza automáticamente
```bash
npm run start
```

---

## 📊 Consultas en SQLite

### Ver base de datos con CLI
```bash
# Instalar sqlite3 CLI
# Windows: https://www.sqlite.org/download.html

# Luego:
sqlite3 database/whatsapp_agent.db
sqlite> .tables
sqlite> SELECT COUNT(*) FROM companies;
sqlite> .quit
```

### Backups
```bash
# Copiar archivo de BD
cp database/whatsapp_agent.db database/whatsapp_agent_backup.db
```

---

## ⚡ Ventajas SQLite

✅ **Desarrollo rápido:** Sin configuración
✅ **Perfecto para pruebas:** Archivo único
✅ **Fácil de compartir:** Adjunta el `.db` en email
✅ **Debugging:** Abre con cualquier herramienta SQLite GUI
✅ **Zero overhead:** Servidor corriendo en tu PC

---

## ⚠️ Limitaciones (para Producción)

❌ Concurrencia limitada
❌ Sin replicación
❌ Limite de tamaño (teoricamente 140TB, prácticamente ~100GB)
❌ Sin usuarios/permisos por tabla

**Solución:** Migra a PostgreSQL cuando crezcas 📈

---

## 🎯 Próximos Pasos

1. ✅ Servidor iniciándose con SQLite
2. ⏳ Espera a ver "Server running on port 3000"
3. ✅ Prueba `/health`
4. ✅ Registra una empresa con `/api/companies/register`
5. ✅ Crea un agente con `/api/agents`

---

¡SQLite está listo! 🚀
