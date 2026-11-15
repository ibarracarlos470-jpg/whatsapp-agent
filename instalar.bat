@echo off
echo ========================================
echo WhatsApp Agent - Installation Script
echo ========================================
echo.

cd /d "%~dp0"

echo Paso 1: Instalando dependencias...
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo Error durante npm install
    pause
    exit /b 1
)

echo.
echo Paso 2: Creando archivo .env...

if not exist ".env" (
    copy .env.example .env
    echo Archivo .env creado. Actualiza tus credenciales.
) else (
    echo .env ya existe
)

echo.
echo ========================================
echo Instalacion completada!
echo ========================================
echo.
echo Proximo paso:
echo 1. Edita el archivo .env con tus credenciales
echo 2. Asegure que PostgreSQL este corriendo
echo 3. Ejecuta: npm run dev
echo.
pause
