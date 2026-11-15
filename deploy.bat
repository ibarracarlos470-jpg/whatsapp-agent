@echo off
setlocal enabledelayedexpansion

REM Script de deployment a Heroku

set HEROKU_CLI=C:\Program Files\heroku\bin\heroku.cmd
set GIT_EXE=C:\Program Files\Git\cmd\git.exe

REM Configurar variables de entorno
set PATH=C:\Program Files\heroku\bin;C:\Program Files\Git\cmd;%PATH%

echo ========================================
echo WhatsApp Agent - Heroku Deployment
echo ========================================
echo.

REM Verificar herramientas
echo Verificando herramientas instaladas...
"%HEROKU_CLI%" --version
"%GIT_EXE%" --version

REM Configurar git
echo.
echo Configurando Git...
"%GIT_EXE%" config --global user.name "Deploy Bot"
"%GIT_EXE%" config --global user.email "deploy@whatsapp.local"

REM Inicializar repo si no existe
if not exist ".git" (
    echo Inicializando repositorio Git...
    "%GIT_EXE%" init
)

REM Agregar archivos
echo.
echo Agregando archivos...
"%GIT_EXE%" add .

REM Verificar estado
echo.
echo Estado del repositorio:
"%GIT_EXE%" status

REM Commit
echo.
echo Creando commit...
"%GIT_EXE%" commit -m "Initial: WhatsApp Agent Heroku deployment"

REM Mostrar commits
echo.
echo Historial de commits:
"%GIT_EXE%" log --oneline -5

REM Instrucciones para Heroku
echo.
echo ========================================
echo Próximos pasos:
echo 1. Ejecuta: %HEROKU_CLI% login
echo 2. Ejecuta: %HEROKU_CLI% create whatsapp-agent-marcelo
echo 3. Ejecuta: %HEROKU_CLI% config:set -a whatsapp-agent-marcelo GEMINI_API_KEY=AQ.Ab8RN6I592w8SiaxYQj4uTcNhu66_5-MdBdOU0Oa0zJTb8kZBg WHATSAPP_API_TOKEN=EAAepZB3wn6wIBS2Lov8G2EYGGXzAJi53IZAguJghAYRKEtSYapRnofF0bk5tL6YcttGZBkW7mKZCEEOiFsAdMpd2VZBOYdfmCNbflxsyFcr2fC7ZA12CVhZBwXOMJGaGT9PYsZAZBRO6ZBYzbrRXyBwAdkg0yeRRGHPyYjpwn862GGBhNAmzBL6Gz8VPFLjUrh9biQifgyb8cSc9KZC8MATvHZBLpwWr2RsonDMeeZAb39wFH5xHlEDcO1UZALDyZCJAABXqQQikGDtWtYMVj3ZCjsuM2siYZBQZDZD WHATSAPP_PHONE_NUMBER_ID=1234567890 META_VERIFY_TOKEN=e24e347dcb0a98b4e98a95a467718248 JWT_SECRET=tu_jwt_mega_secreto_seguro_123 NODE_ENV=production
echo 4. Ejecuta: git push heroku main
echo ========================================

pause
