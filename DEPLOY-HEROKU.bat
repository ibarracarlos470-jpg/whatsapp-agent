@echo off
setlocal enabledelayedexpansion

REM ╔═══════════════════════════════════════════════════════════════╗
REM ║        DEPLOYMENT AUTOMÁTICO A HEROKU - WHATSAPP AGENT       ║
REM ╚═══════════════════════════════════════════════════════════════╝

echo.
echo ════════════════════════════════════════════════════════════════
echo    DEPLOYMENT AUTOMÁTICO A HEROKU - WHATSAPP AGENT
echo ════════════════════════════════════════════════════════════════
echo.

REM Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ✗ ADVERTENCIA: Este script debería ejecutarse como Administrador
    echo.
    echo Pasos para ejecutar como Administrador:
    echo   1. Presiona Ctrl+Shift+Esc para abrir Task Manager
    echo   2. Abre PowerShell desde Task Manager como Administrador
    echo   3. Navega a esta carpeta y ejecuta el script
    echo.
    pause
    exit /b 1
)

REM Configurar PATH
set PATH=%PATH%;C:\Program Files\heroku\bin;C:\Program Files\nodejs;C:\Program Files\Git\cmd

REM Paso 1: Verificar requisitos
echo [1/3] Verificando requisitos...

git --version >nul 2>&1
if %errorLevel% neq 0 (
    echo ✗ Git no encontrado
    exit /b 1
)
echo ✓ Git encontrado

heroku --version >nul 2>&1
if %errorLevel% neq 0 (
    echo ✗ Heroku CLI no encontrado
    exit /b 1
)
echo ✓ Heroku CLI encontrado

node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo ✗ Node.js no encontrado
    exit /b 1
)
echo ✓ Node.js encontrado

REM Paso 2: Verificar autenticación
echo.
echo [2/3] Verificando autenticación con Heroku...

heroku auth:whoami >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ✗ No autenticado con Heroku
    echo.
    echo Ejecuta uno de estos comandos en PowerShell como Administrador:
    echo.
    echo Opción 1: Login normal
    echo   heroku login
    echo.
    echo Opción 2: Usar API Key directa
    echo   1. Ve a: https://dashboard.heroku.com/account/applications/authorizations
    echo   2. Copia una API Key
    echo   3. Ejecuta: $env:HEROKU_API_KEY = 'tu_api_key'
    echo.
    pause
    exit /b 1
)
echo ✓ Autenticado con Heroku

REM Paso 3: Ejecutar el script de PowerShell
echo.
echo [3/3] Iniciando deployment...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0DEPLOYMENT-COMPLETE.ps1"

REM Capturar código de salida
if %errorLevel% equ 0 (
    echo.
    echo ════════════════════════════════════════════════════════════════
    echo ✓ DEPLOYMENT COMPLETADO
    echo ════════════════════════════════════════════════════════════════
    echo.
    echo Tu app está desplegada en Heroku.
    echo.
) else (
    echo.
    echo ════════════════════════════════════════════════════════════════
    echo ✗ ERROR EN DEPLOYMENT
    echo ════════════════════════════════════════════════════════════════
    echo.
)

pause
