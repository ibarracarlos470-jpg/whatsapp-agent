@echo off
setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║   DEPLOY AUTOMATICO A HEROKU - WhatsApp Agent        ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Verificar si Heroku está instalado
echo Verificando Heroku CLI...
heroku --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ ERROR: Heroku CLI no está instalado
    echo.
    echo Descargalo desde:
    echo https://devcenter.heroku.com/articles/heroku-cli
    echo.
    echo Luego vuelve a ejecutar este script
    pause
    exit /b 1
)

echo ✅ Heroku CLI encontrado
echo.

REM Verificar autenticación
echo Verificando login en Heroku...
heroku auth:whoami >nul 2>&1
if errorlevel 1 (
    echo.
    echo Abriendo navegador para login...
    heroku login
)

echo ✅ Autenticado
echo.

REM Pedir nombre de la app
set /p APP_NAME="Nombre de la app en Heroku (ej: whatsapp-agent-marcelo): "

if "!APP_NAME!"=="" (
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
    set APP_NAME=whatsapp-agent-!mydate!!mytime!
    echo Usando: !APP_NAME!
)

echo.
echo PASO 1: Inicializar Git
git init
git add .
git commit -m "WhatsApp Agent Deploy a Heroku"

echo.
echo PASO 2: Crear app en Heroku
heroku create !APP_NAME!

echo.
echo PASO 3: Configurar variables de entorno
heroku config:set -a !APP_NAME! ^
  GEMINI_API_KEY=AQ.Ab8RN6I592w8SiaxYQj4uTcNhu66_5-MdBdOU0Oa0zJTb8kZBg ^
  WHATSAPP_API_TOKEN=EAAepZB3wn6wIBS2Lov8G2EYGGXzAJi53IZAguJghAYRKEtSYapRnofF0bk5tL6YcttGZBkW7mKZCEEOiFsAdMpd2VZBOYdfmCNbflxsyFcr2fC7ZA12CVhZBwXOMJGaGT9PYsZAZBRO6ZBYzbrRXyBwAdkg0yeRRGHPyYjpwn862GGBhNAmzBL6Gz8VPFLjUrh9biQifgyb8cSc9KZC8MATvHZBLpwWr2RsonDMeeZAb39wFH5xHlEDcO1UZALDyZCJAABXqQQikGDtWtYMVj3ZCjsuM2siYZBQZDZD ^
  WHATSAPP_PHONE_NUMBER_ID=1234567890 ^
  META_VERIFY_TOKEN=e24e347dcb0a98b4e98a95a467718248 ^
  JWT_SECRET=tu_jwt_mega_secreto_seguro ^
  NODE_ENV=production

echo.
echo PASO 4: DEPLOYAR A HEROKU
echo Esto puede tomar 2-3 minutos...
echo.

git push heroku main

if errorlevel 1 (
    echo.
    echo ❌ Error durante el deploy
    pause
    exit /b 1
)

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║         ✅ DEPLOY EXITOSO                             ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Tu app está en:
echo https://!APP_NAME!.herokuapp.com
echo.
echo Prueba:
echo https://!APP_NAME!.herokuapp.com/health
echo.
echo Ver logs:
echo heroku logs -a !APP_NAME! --tail
echo.
pause
