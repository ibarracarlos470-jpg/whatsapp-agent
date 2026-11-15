# 🚀 DEPLOY A HEROKU - ULTRA SIMPLE

## ⚠️ ÚNICO REQUISITO:

**Heroku CLI debe estar instalado**

Descarga desde: https://devcenter.heroku.com/articles/heroku-cli

---

## 🎯 SÓLO 2 PASOS:

### PASO 1: Instala Heroku CLI

1. Ve a: https://devcenter.heroku.com/articles/heroku-cli
2. Click en "Download" para Windows
3. Ejecuta el instalador (heroku-x64.exe)
4. **REINICIA LA TERMINAL** cuando termine

Verifica:
```bash
heroku --version
```

---

### PASO 2: Ejecuta el Script de Deploy

1. Abre PowerShell
2. Navega a la carpeta del proyecto:
```bash
cd C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent
```

3. Ejecuta el script:
```bash
.\DEPLOY-AUTOMATICO.bat
```

4. Cuando pregunte el nombre de la app:
```
Nombre de la app: whatsapp-agent-marcelo
```

5. **ESPERA 2-3 MINUTOS** mientras compila y deploya

---

## ✅ CUANDO TERMINE:

Verás:
```
✅ DEPLOY EXITOSO

Tu app está en:
https://whatsapp-agent-marcelo.herokuapp.com
```

---

## 🧪 PRUEBA:

Abre en navegador:
```
https://whatsapp-agent-marcelo.herokuapp.com
```

Deberías ver el LOGIN! 🎉

---

## 📊 VER LOGS:

```bash
heroku logs -a whatsapp-agent-marcelo --tail
```

---

## 🎊 ¡LISTO!

Tu app está en la nube, accesible desde cualquier lado. 

Ahora a vender! 💰

---

## 🆘 SI ALGO FALLA:

Error común: "heroku: command not found"
→ Reinicia PowerShell completamente

Error: "Permission denied"
→ Abre PowerShell como Administrador

Error: "git not found"
→ Instala Git desde: https://git-scm.com/

---

**¿NECESITAS AYUDA?** Lee DEPLOY-HEROKU.md para más detalles.
