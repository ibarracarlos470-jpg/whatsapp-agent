@echo off
REM ============================================
REM DEPLOY FINAL A HEROKU - WHATSAPP AGENT
REM Ejecutar como ADMINISTRADOR
REM ============================================

setlocal enabledelayedexpansion
cd /d "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"

echo.
echo ========================================
echo DEPLOY A HEROKU - WHATSAPP AGENT
echo ========================================
echo.

REM Ejecutar el script PowerShell
powershell -ExecutionPolicy Bypass -File "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent\deploy-heroku-final.ps1"

pause
