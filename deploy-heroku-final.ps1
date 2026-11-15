# ============================================
# DEPLOY FINAL A HEROKU - WHATSAPP AGENT
# Ejecutar como ADMINISTRADOR en PowerShell
# ============================================

$ErrorActionPreference = "Continue"
$HEROKU = "C:\Program Files\Heroku\bin\heroku.cmd"
$projectPath = "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"

Write-Host "
========================================
DEPLOY A HEROKU - WHATSAPP AGENT
========================================
" -ForegroundColor Green

# Cambiar al directorio del proyecto
cd $projectPath
Write-Host "✓ Directorio: $projectPath" -ForegroundColor Green

# 1. VERIFICAR AUTENTICACIÓN
Write-Host "`n[PASO 1] Verificando autenticación en Heroku..." -ForegroundColor Yellow
$authCheck = & $HEROKU auth:whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠ No autenticado. Iniciando sesión..." -ForegroundColor Yellow
    Write-Host "Se abrirá un navegador. Por favor, inicia sesión con tu cuenta de Heroku." -ForegroundColor Cyan
    & $HEROKU login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error en autenticación" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Autenticación completada" -ForegroundColor Green
} else {
    Write-Host "✓ Autenticado como: $authCheck" -ForegroundColor Green
}

# 2. INICIALIZAR GIT
Write-Host "`n[PASO 2] Inicializando Git..." -ForegroundColor Yellow
if (Test-Path ".\.git") {
    Write-Host "✓ Git ya está inicializado" -ForegroundColor Green
} else {
    Write-Host "Inicializando repositorio Git..." -ForegroundColor Cyan
    git init 2>$null
    git config user.name "Marcelo" 2>$null
    git config user.email "marcelo@whatsapp.local" 2>$null
    git add . 2>$null
    git commit -m "WhatsApp Agent - Deploy a Heroku" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Git inicializado y commit creado" -ForegroundColor Green
    } else {
        Write-Host "⚠ Advertencia en Git (puede estar vacío)" -ForegroundColor Yellow
    }
}

# 3. CREAR APP EN HEROKU
Write-Host "`n[PASO 3] Creando app en Heroku..." -ForegroundColor Yellow
$appName = "whatsapp-agent-marcelo"
$appExists = & $HEROKU apps 2>$null | Select-String $appName
if ($appExists) {
    Write-Host "✓ App ya existe: $appName" -ForegroundColor Green
} else {
    Write-Host "Creando nueva app..." -ForegroundColor Cyan
    & $HEROKU create $appName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ App creada: $appName" -ForegroundColor Green
    } else {
        Write-Host "✗ Error al crear app" -ForegroundColor Red
        exit 1
    }
}

# 4. CONFIGURAR VARIABLES DE ENTORNO
Write-Host "`n[PASO 4] Configurando variables de entorno..." -ForegroundColor Yellow
Write-Host "Esto puede tomar algunos segundos..." -ForegroundColor Cyan

$configVars = @{
    "GEMINI_API_KEY" = "AQ.Ab8RN6I592w8SiaxYQj4uTcNhu66_5-MdBdOU0Oa0zJTb8kZBg"
    "WHATSAPP_API_TOKEN" = "EAAepZB3wn6wIBS2Lov8G2EYGGXzAJi53IZAguJghAYRKEtSYapRnofF0bk5tL6YcttGZBkW7mKZCEEOiFsAdMpd2VZBOYdfmCNbflxsyFcr2fC7ZA12CVhZBwXOMJGaGT9PYsZAZBRO6ZBYzbrRXyBwAdkg0yeRRGHPyYjpwn862GGBhNAmzBL6Gz8VPFLjUrh9biQifgyb8cSc9KZC8MATvHZBLpwWr2RsonDMeeZAb39wFH5xHlEDcO1UZALDyZCJAABXqQQikGDtWtYMVj3ZCjsuM2siYZBQZDZD"
    "WHATSAPP_PHONE_NUMBER_ID" = "1234567890"
    "META_VERIFY_TOKEN" = "e24e347dcb0a98b4e98a95a467718248"
    "JWT_SECRET" = "tu_jwt_mega_secreto_seguro_123"
    "NODE_ENV" = "production"
}

$configCmd = "& `"$HEROKU`" config:set -a $appName"
foreach ($key in $configVars.Keys) {
    $value = $configVars[$key]
    $configCmd += " $key=`"$value`""
}

Invoke-Expression $configCmd
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Variables configuradas" -ForegroundColor Green
} else {
    Write-Host "⚠ Advertencia al configurar variables (pueden ya existir)" -ForegroundColor Yellow
}

# 5. HACER PUSH A HEROKU
Write-Host "`n[PASO 5] Haciendo push a Heroku (esto toma 2-3 minutos)..." -ForegroundColor Yellow
Write-Host "Compilando aplicación..." -ForegroundColor Cyan

if (Test-Path ".\.git") {
    # Agregar remote de heroku si no existe
    $remotes = git remote 2>$null
    if ($remotes -notcontains "heroku") {
        & $HEROKU git:remote -a $appName 2>$null
    }

    # Hacer push
    git push heroku main 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Deploy completado con éxito" -ForegroundColor Green
    } else {
        Write-Host "⚠ Posible error en el deploy. Verificando logs..." -ForegroundColor Yellow
        & $HEROKU logs --tail -a $appName | Select-Object -Last 20
    }
} else {
    Write-Host "✗ Git no está inicializado. Por favor, intenta de nuevo." -ForegroundColor Red
    exit 1
}

# 6. VERIFICAR DESPLIEGUE
Write-Host "`n[PASO 6] Verificando despliegue..." -ForegroundColor Yellow
Write-Host "Esperando 10 segundos a que la app inicie..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

$appUrl = "https://$appName.herokuapp.com/health"
Write-Host "Verificando: $appUrl" -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri $appUrl -TimeoutSec 10 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ App respondiendo correctamente" -ForegroundColor Green
        Write-Host "Respuesta: $($response.Content)" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ App aún está iniciando o hay un error" -ForegroundColor Yellow
    Write-Host "Logs recientes:" -ForegroundColor Cyan
    & $HEROKU logs --tail -a $appName | Select-Object -Last 10
}

# 7. RESUMEN FINAL
Write-Host "
========================================
RESUMEN DEL DEPLOY
========================================
" -ForegroundColor Green

Write-Host "✓ App Name: $appName" -ForegroundColor Green
Write-Host "✓ URL: https://$appName.herokuapp.com" -ForegroundColor Green
Write-Host "✓ Health Check: https://$appName.herokuapp.com/health" -ForegroundColor Green
Write-Host "
Para ver logs en tiempo real:" -ForegroundColor Cyan
Write-Host "  heroku logs --tail -a $appName" -ForegroundColor Cyan
Write-Host "
Para acceder a la app:" -ForegroundColor Cyan
Write-Host "  heroku open -a $appName" -ForegroundColor Cyan
Write-Host "
========================================" -ForegroundColor Green
