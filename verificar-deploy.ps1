# ============================================
# VERIFICAR ESTADO PARA DEPLOY A HEROKU
# ============================================

Write-Host "
========================================
VERIFICACIÓN PRE-DEPLOY A HEROKU
========================================
" -ForegroundColor Green

$projectPath = "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"
$HEROKU = "C:\Program Files\Heroku\bin\heroku.cmd"

cd $projectPath

# 1. Verificar archivos esenciales
Write-Host "`n[1] Verificando archivos esenciales..." -ForegroundColor Yellow

$files = @(
    "package.json",
    "Procfile",
    "src/index.js",
    ".gitignore",
    ".env"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file (FALTA)" -ForegroundColor Red
    }
}

# 2. Verificar Node.js
Write-Host "`n[2] Verificando Node.js..." -ForegroundColor Yellow
$nodeVersion = & node --version 2>&1
if ($nodeVersion) {
    Write-Host "  ✓ Node.js $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ Node.js no encontrado" -ForegroundColor Red
}

# 3. Verificar npm
Write-Host "`n[3] Verificando npm..." -ForegroundColor Yellow
$npmVersion = & npm --version 2>&1
if ($npmVersion) {
    Write-Host "  ✓ npm $npmVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ npm no encontrado" -ForegroundColor Red
}

# 4. Verificar Git
Write-Host "`n[4] Verificando Git..." -ForegroundColor Yellow
$gitVersion = & git --version 2>&1
if ($gitVersion) {
    Write-Host "  ✓ Git instalado" -ForegroundColor Green
    if (Test-Path ".\.git") {
        Write-Host "  ✓ Repositorio Git inicializado" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Repositorio Git NO inicializado (se hará durante deploy)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✗ Git no encontrado" -ForegroundColor Red
}

# 5. Verificar Heroku CLI
Write-Host "`n[5] Verificando Heroku CLI..." -ForegroundColor Yellow
$herokuVersion = & $HEROKU --version 2>&1
if ($herokuVersion) {
    Write-Host "  ✓ Heroku CLI: $herokuVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ Heroku CLI no encontrado" -ForegroundColor Red
}

# 6. Verificar autenticación Heroku
Write-Host "`n[6] Verificando autenticación Heroku..." -ForegroundColor Yellow
$authCheck = & $HEROKU auth:whoami 2>&1
if ($authCheck -and $authCheck -notmatch "not logged in") {
    Write-Host "  ✓ Autenticado en Heroku como: $authCheck" -ForegroundColor Green
} else {
    Write-Host "  ⚠ NO autenticado en Heroku (se pedirá durante deploy)" -ForegroundColor Yellow
}

# 7. Verificar variables de entorno
Write-Host "`n[7] Verificando variables de entorno en .env..." -ForegroundColor Yellow
$env_vars = @(
    "GEMINI_API_KEY",
    "WHATSAPP_API_TOKEN",
    "WHATSAPP_PHONE_NUMBER_ID",
    "META_VERIFY_TOKEN",
    "JWT_SECRET"
)

$envContent = Get-Content ".env" -Raw
foreach ($var in $env_vars) {
    if ($envContent -match $var) {
        Write-Host "  ✓ $var (configurado)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $var (NO ENCONTRADO)" -ForegroundColor Red
    }
}

# 8. Verificar node_modules
Write-Host "`n[8] Verificando dependencias..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    $nodeModulesCount = (Get-ChildItem "node_modules" -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
    Write-Host "  ✓ node_modules existe ($nodeModulesCount elementos)" -ForegroundColor Green
} else {
    Write-Host "  ⚠ node_modules NO existe (necesitarás ejecutar 'npm install')" -ForegroundColor Yellow
}

# 9. Verificar disponibilidad de nombre de app
Write-Host "`n[9] Verificando disponibilidad de nombre de app..." -ForegroundColor Yellow
$appName = "whatsapp-agent-marcelo"
$apps = & $HEROKU apps 2>&1
if ($apps -match $appName) {
    Write-Host "  ✓ App '$appName' ya existe" -ForegroundColor Green
} else {
    Write-Host "  ✓ Nombre de app '$appName' disponible" -ForegroundColor Green
}

# Resumen final
Write-Host "
========================================
RESUMEN
========================================
" -ForegroundColor Green

Write-Host "
Proyecto: WhatsApp Agent" -ForegroundColor Cyan
Write-Host "Ubicación: $projectPath" -ForegroundColor Cyan
Write-Host "App Heroku: $appName" -ForegroundColor Cyan
Write-Host "URL esperada: https://$appName.herokuapp.com" -ForegroundColor Cyan

Write-Host "
PRÓXIMOS PASOS:
1. Ejecuta: deploy-heroku-final.bat
   O
2. Ejecuta: deploy-heroku-final.ps1

El script completará el deploy automáticamente.
" -ForegroundColor Green
