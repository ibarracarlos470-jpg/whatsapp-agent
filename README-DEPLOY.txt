╔════════════════════════════════════════════════════════════════════════════╗
║         WHATSAPP AGENT - DEPLOY A HEROKU                                   ║
║                                                                            ║
║  Estado: LISTO PARA DEPLOY                                               ║
║  Fecha: 15/11/2026                                                         ║
╚════════════════════════════════════════════════════════════════════════════╝


┌─ INICIO RÁPIDO ──────────────────────────────────────────────────────────┐
│                                                                            │
│  OPCIÓN 1: Ejecutar script batch (RECOMENDADO)                            │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │ 1. Click derecho en: deploy-heroku-final.bat                    │    │
│  │ 2. Selecciona: "Ejecutar como administrador"                    │    │
│  │ 3. Espera a que termine (2-3 minutos)                           │    │
│  │ 4. ¡LISTO! Tu app estará en: https://whatsapp-agent-marcelo... │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                            │
│  OPCIÓN 2: Verificar estado antes de deploy                               │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │ PowerShell Admin > .\verificar-deploy.ps1                       │    │
│  │ Esto verificará que todo está listo                             │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ DETALLES DEL PROYECTO ──────────────────────────────────────────────────┐
│                                                                            │
│  Nombre:              WhatsApp Agent                                       │
│  Framework:          Node.js + Express                                    │
│  IA:                  Google Gemini API                                    │
│  Plataforma:          Heroku                                              │
│  App Name:            whatsapp-agent-marcelo                              │
│  URL Production:      https://whatsapp-agent-marcelo.herokuapp.com        │
│  Health Check:        https://whatsapp-agent-marcelo.herokuapp.com/health │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ ARCHIVOS INCLUIDOS EN EL DEPLOY ────────────────────────────────────────┐
│                                                                            │
│  Esenciales:                                                              │
│  ├─ package.json          ✓ Dependencias del proyecto                    │
│  ├─ Procfile              ✓ Configuración de Heroku                      │
│  ├─ src/index.js          ✓ Entrada principal de la app                  │
│  ├─ .env                  ✓ Variables de entorno                         │
│  ├─ .gitignore            ✓ Archivos a ignorar en git                    │
│  ├─ node_modules/         ✓ Dependencias instaladas                      │
│  ├─ database/             ✓ Base de datos SQLite                         │
│  ├─ frontend/             ✓ Interfaz web                                 │
│  ├─ logs/                 ✓ Carpeta de logs                              │
│  │                                                                         │
│  Scripts de Deploy:                                                       │
│  ├─ deploy-heroku-final.bat           Ejecutable batch                   │
│  ├─ deploy-heroku-final.ps1           Script PowerShell completo         │
│  ├─ verificar-deploy.ps1              Verificación pre-deploy            │
│  ├─ DEPLOY-HEROKU-INSTRUCCIONES.txt   Instrucciones detalladas           │
│  └─ README-DEPLOY.txt                 Este archivo                       │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ VARIABLES DE ENTORNO CONFIGURADAS ──────────────────────────────────────┐
│                                                                            │
│  ✓ GEMINI_API_KEY                Google Gemini para IA                   │
│  ✓ WHATSAPP_API_TOKEN           Token de Meta/WhatsApp                   │
│  ✓ WHATSAPP_PHONE_NUMBER_ID     ID del número de WhatsApp                │
│  ✓ META_VERIFY_TOKEN             Token de verificación de Meta            │
│  ✓ JWT_SECRET                    Secreto para tokens JWT                 │
│  ✓ NODE_ENV                      production (configurado)                │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ PROCESO DE DEPLOY ──────────────────────────────────────────────────────┐
│                                                                            │
│  El script deploy-heroku-final.ps1 ejecutará automáticamente:             │
│                                                                            │
│  1. ✓ Verificar autenticación en Heroku (login si es necesario)          │
│  2. ✓ Inicializar Git (si no está inicializado)                          │
│  3. ✓ Crear app en Heroku: "whatsapp-agent-marcelo"                      │
│  4. ✓ Configurar todas las variables de entorno                          │
│  5. ✓ Hacer push del código (git push heroku main)                       │
│  6. ✓ Compilar la app (2-3 minutos)                                      │
│  7. ✓ Verificar que la app está corriendo                                │
│  8. ✓ Mostrar URL de acceso                                              │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ RESULTADOS ESPERADOS ───────────────────────────────────────────────────┐
│                                                                            │
│  Después del deploy exitoso:                                              │
│                                                                            │
│  URL Principal:                                                           │
│  https://whatsapp-agent-marcelo.herokuapp.com                            │
│                                                                            │
│  Health Check:                                                            │
│  https://whatsapp-agent-marcelo.herokuapp.com/health                     │
│  Respuesta esperada:                                                      │
│  {"status":"healthy","message":"WhatsApp Agent is running"}             │
│                                                                            │
│  Logs en tiempo real:                                                     │
│  heroku logs --tail -a whatsapp-agent-marcelo                           │
│                                                                            │
│  Dashboard Heroku:                                                        │
│  https://dashboard.heroku.com/apps/whatsapp-agent-marcelo               │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ REQUISITOS PREVIOS ─────────────────────────────────────────────────────┐
│                                                                            │
│  Verificaremos durante el deploy:                                         │
│                                                                            │
│  ✓ Heroku CLI instalado (C:\Program Files\Heroku)                         │
│  ✓ Git instalado                                                          │
│  ✓ Node.js y npm disponibles                                              │
│  ✓ Variables de entorno configuradas en .env                             │
│  ✓ Procfile existe y está correctamente configurado                      │
│  ✓ PowerShell ejecutado como Administrador                               │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ TROUBLESHOOTING ────────────────────────────────────────────────────────┐
│                                                                            │
│  Problema: "Git no reconocido"                                            │
│  Solución: Ejecuta PowerShell como Administrador y vuelve a intentar     │
│                                                                            │
│  Problema: "Heroku not logged in"                                         │
│  Solución: Ejecuta 'heroku login' cuando el script lo pida                │
│            Se abrirá un navegador, inicia sesión con tu cuenta            │
│                                                                            │
│  Problema: "App no responde después del deploy"                           │
│  Solución: Ve los logs: heroku logs --tail -a whatsapp-agent-marcelo    │
│            Espera 30 segundos más, la app puede estar iniciando          │
│                                                                            │
│  Problema: "Port already in use" en logs                                  │
│  Solución: Heroku usa PORT automáticamente, el script lo configura       │
│                                                                            │
│  Problema: "Cannot find module"                                           │
│  Solución: Las dependencias se instalan automáticamente durante deploy    │
│            Si falla, verifica que package.json es válido                  │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ COMANDOS ÚTILES DESPUÉS DEL DEPLOY ─────────────────────────────────────┐
│                                                                            │
│  Ver logs en tiempo real:                                                 │
│  $ heroku logs --tail -a whatsapp-agent-marcelo                          │
│                                                                            │
│  Abrir la app en el navegador:                                            │
│  $ heroku open -a whatsapp-agent-marcelo                                 │
│                                                                            │
│  Ver configuración de variables:                                          │
│  $ heroku config -a whatsapp-agent-marcelo                               │
│                                                                            │
│  Reiniciar la app:                                                        │
│  $ heroku restart -a whatsapp-agent-marcelo                              │
│                                                                            │
│  Ver procesos en ejecución:                                               │
│  $ heroku ps -a whatsapp-agent-marcelo                                   │
│                                                                            │
│  Escalar dyos (aumentar capacidad):                                       │
│  $ heroku ps:scale web=2 -a whatsapp-agent-marcelo                       │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


┌─ INFORMACIÓN ADICIONAL ──────────────────────────────────────────────────┐
│                                                                            │
│  Tecnologías utilizadas:                                                  │
│  • Node.js: Runtime de JavaScript en servidor                             │
│  • Express: Framework web                                                 │
│  • Gemini API: IA de Google para procesamiento de mensajes               │
│  • Meta API: Integración con WhatsApp y Facebook                          │
│  • SQLite: Base de datos local                                            │
│  • Redis: Cache y colas (opcional en producción)                          │
│  • Heroku: Plataforma cloud para hosting                                  │
│                                                                            │
│  Tiempo estimado de deploy:                                               │
│  1-2 min: Preparación                                                     │
│  2-3 min: Compilación y instalación de dependencias                      │
│  1 min: Iniciación de la app                                              │
│  ─────────────────────                                                    │
│  Total: 4-6 minutos aproximadamente                                       │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘


╔════════════════════════════════════════════════════════════════════════════╗
║                        ¡LISTO PARA DEPLOY!                                ║
║                                                                            ║
║  Próximo paso: Ejecuta deploy-heroku-final.bat como Administrador         ║
║                                                                            ║
║  ¿Preguntas? Revisa DEPLOY-HEROKU-INSTRUCCIONES.txt para instrucciones   ║
║  detalladas y opciones de ejecución manual.                               ║
╚════════════════════════════════════════════════════════════════════════════╝
