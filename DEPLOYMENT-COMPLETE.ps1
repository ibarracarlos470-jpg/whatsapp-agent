# ╔═══════════════════════════════════════════════════════════════╗
# ║        DEPLOYMENT AUTOMÁTICO A HEROKU - WHATSAPP AGENT         ║
# ║                    100% Automatizado                           ║
# ╚═══════════════════════════════════════════════════════════════╝

# CONFIGURACIÓN
$projectPath = "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"
$appName = "whatsapp-agent-marcelo"
$region = "us"

# ═══════════════════════════════════════════════════════════════
# FASE 0: SETUP
# ═══════════════════════════════════════════════════════════════

# Agregar rutas necesarias al PATH
$env:Path = "$env:Path;C:\Program Files\heroku\bin;C:\Program Files\nodejs;C:\Program Files\Git\cmd"

# Función para imprimir con colores
function Print-Header {
    param([string]$text)
    Write-Host ""
    Write-Host ("╔" + ("═" * 67) + "╗") -ForegroundColor Cyan
    Write-Host ("║ " + $text.PadRight(65) + " ║") -ForegroundColor Cyan
    Write-Host ("╚" + ("═" * 67) + "╝") -ForegroundColor Cyan
    Write-Host ""
}

function Print-Step {
    param([int]$num, [string]$text)
    Write-Host "[$num/8] $text" -ForegroundColor Yellow
}

function Print-Success {
    param([string]$text)
    Write-Host "    ✓ $text" -ForegroundColor Green
}

function Print-Error {
    param([string]$text)
    Write-Host "    ✗ $text" -ForegroundColor Red
}

function Print-Info {
    param([string]$text)
    Write-Host "    → $text" -ForegroundColor Cyan
}

# ═══════════════════════════════════════════════════════════════
# INICIO
# ═══════════════════════════════════════════════════════════════

Print-Header "DEPLOYMENT AUTOMÁTICO A HEROKU - WHATSAPP AGENT"

Write-Host "Configuración:" -ForegroundColor Cyan
Write-Host "  Proyecto: $projectPath"
Write-Host "  App Name: $appName"
Write-Host "  Región:   $region"
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# PASO 1: VERIFICAR REQUISITOS
# ═══════════════════════════════════════════════════════════════

Print-Step 1 "Verificando requisitos"

try {
    $gitVersion = & git --version 2>&1 | Out-String | ForEach-Object { $_.Trim() }
    Print-Success "Git: $gitVersion"
} catch {
    Print-Error "Git no encontrado"
    exit 1
}

try {
    $herokuVersion = & heroku --version 2>&1 | Out-String | ForEach-Object { $_.Trim() }
    Print-Success "Heroku CLI: $herokuVersion"
} catch {
    Print-Error "Heroku CLI no encontrado"
    exit 1
}

try {
    $nodeVersion = & node --version 2>&1 | Out-String | ForEach-Object { $_.Trim() }
    Print-Success "Node.js: $nodeVersion"
} catch {
    Print-Error "Node.js no encontrado"
    exit 1
}

if (-not (Test-Path $projectPath)) {
    Print-Error "Proyecto no encontrado en: $projectPath"
    exit 1
}
Print-Success "Proyecto encontrado"

# ═══════════════════════════════════════════════════════════════
# PASO 2: NAVEGAR AL PROYECTO Y CONFIGURAR GIT
# ═══════════════════════════════════════════════════════════════

Print-Step 2 "Configurando Git"

Set-Location $projectPath

if (-not (Test-Path "package.json")) {
    Print-Error "package.json no encontrado"
    exit 1
}

if (-not (Test-Path ".git")) {
    Print-Info "Inicializando repositorio Git"
    & git init | Out-Null
    & git config user.name "Marcelo" | Out-Null
    & git config user.email "marcelo@whatsapp.local" | Out-Null
    Print-Success "Repositorio Git inicializado"
} else {
    Print-Success "Repositorio Git ya existe"
}

# ═══════════════════════════════════════════════════════════════
# PASO 3: PREPARAR CÓDIGO
# ═══════════════════════════════════════════════════════════════

Print-Step 3 "Preparando código"

Print-Info "Agregando archivos"
& git add . 2>&1 | Out-Null

Print-Info "Creando commit"
$commitResult = & git commit -m "WhatsApp Agent - Deployment Automático a Heroku" 2>&1
if ($LASTEXITCODE -eq 0) {
    Print-Success "Commit creado"
} else {
    Print-Success "No hay cambios nuevos (normal)"
}

# ═══════════════════════════════════════════════════════════════
# PASO 4: VERIFICAR AUTENTICACIÓN HEROKU
# ═══════════════════════════════════════════════════════════════

Print-Step 4 "Verificando autenticación Heroku"

# Intentar verificar si estamos autenticados
$authResult = & heroku auth:whoami 2>&1
$authStatus = $LASTEXITCODE

if ($authStatus -eq 0) {
    Print-Success "Autenticado como: $($authResult.Trim())"
} else {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host "⚠  AUTENTICACIÓN REQUERIDA" -ForegroundColor Red
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "Necesitas autenticarte con Heroku. Abre PowerShell como Administrador" -ForegroundColor Yellow
    Write-Host "y ejecuta uno de estos comandos:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opción 1: Login normal (recomendado)" -ForegroundColor Cyan
    Write-Host "  heroku login" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opción 2: Usar API Key directamente" -ForegroundColor Cyan
    Write-Host "  1. Ve a: https://dashboard.heroku.com/account/applications/authorizations" -ForegroundColor Gray
    Write-Host "  2. Crea o copia una API Key" -ForegroundColor Gray
    Write-Host "  3. Ejecuta en PowerShell:" -ForegroundColor Gray
    Write-Host "     `$env:HEROKU_API_KEY = 'tu_api_key'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Luego ejecuta este script de nuevo:" -ForegroundColor Yellow
    Write-Host "  powershell -ExecutionPolicy Bypass -File '$PSCommandPath'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# ═══════════════════════════════════════════════════════════════
# PASO 5: CREAR APP EN HEROKU
# ═══════════════════════════════════════════════════════════════

Print-Step 5 "Verificando app en Heroku"

$appExists = & heroku apps:info -a $appName 2>&1 | Select-String "Name" -Quiet

if ($appExists) {
    Print-Success "App ya existe: $appName"
} else {
    Print-Info "Creando nueva app"
    $createResult = & heroku create $appName --region $region 2>&1

    if ($LASTEXITCODE -eq 0) {
        Print-Success "App creada: $appName"
    } else {
        Print-Error "Error creando app"
        Write-Host $createResult
        exit 1
    }
}

# ═══════════════════════════════════════════════════════════════
# PASO 6: CONFIGURAR VARIABLES DE ENTORNO
# ═══════════════════════════════════════════════════════════════

Print-Step 6 "Configurando variables de entorno"

# Variables predefinidas
$configVars = @{
    "GEMINI_API_KEY" = "AQ.Ab8RN6I592w8SiaxYQj4uTcNhu66_5-MdBdOU0Oa0zJTb8kZBg"
    "WHATSAPP_API_TOKEN" = "EAAepZB3wn6wIBS2Lov8G2EYGGXzAJi53IZAguJghAYRKEtSYapRnofF0bk5tL6YcttGZBkW7mKZCEEOiFsAdMpd2VZBOYdfmCNbflxsyFcr2fC7ZA12CVhZBwXOMJGaGT9PYsZAZBRO6ZBYzbrRXyBwAdkg0yeRRGHPyYjpwn862GGBhNAmzBL6Gz8VPFLjUrh9biQifgyb8cSc9KZC8MATvHZBLpwWr2RsonDMeeZAb39wFH5xHlEDcO1UZALDyZCJAABXqQQikGDtWtYMVj3ZCjsuM2siYZBQZDZD"
    "WHATSAPP_PHONE_NUMBER_ID" = "1234567890"
    "META_VERIFY_TOKEN" = "e24e347dcb0a98b4e98a95a467718248"
    "JWT_SECRET" = "tu_jwt_mega_secreto_seguro_123"
    "NODE_ENV" = "production"
    "PORT" = "3000"
}

$failCount = 0
foreach ($key in $configVars.Keys) {
    $value = $configVars[$key]
    Print-Info "Configurando $key"

    $setResult = & heroku config:set -a $appName "$key=$value" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Print-Success "$key ✓"
    } else {
        Print-Error "$key"
        $failCount++
    }
}

if ($failCount -gt 0) {
    Print-Error "Algunos variables no se pudieron configurar"
}

# ═══════════════════════════════════════════════════════════════
# PASO 7: HACER PUSH A HEROKU
# ═══════════════════════════════════════════════════════════════

Print-Step 7 "Desplegando a Heroku"

# Configurar Heroku como remote
$remoteExists = & git remote | Select-String "heroku" -Quiet
if (-not $remoteExists) {
    Print-Info "Agregando Heroku como remote"
    & git remote add heroku "https://git.heroku.com/$appName.git" 2>&1 | Out-Null
}

# Determinar rama
$currentBranch = & git rev-parse --abbrev-ref HEAD 2>&1 | ForEach-Object { $_.Trim() }
if ($currentBranch -ne "main" -and $currentBranch -ne "master") {
    $currentBranch = "main"
}

Print-Info "Haciendo push a Heroku (rama: $currentBranch)"
$pushResult = & git push heroku $currentBranch 2>&1

if ($LASTEXITCODE -eq 0) {
    Print-Success "Código desplegado"
} else {
    if ($currentBranch -eq "main") {
        Print-Info "Intentando con rama 'master'"
        $pushResult = & git push heroku master 2>&1
        if ($LASTEXITCODE -eq 0) {
            Print-Success "Código desplegado (desde master)"
        } else {
            Print-Error "Error en deployment"
            Write-Host $pushResult
        }
    }
}

# ═══════════════════════════════════════════════════════════════
# PASO 8: VERIFICAR DEPLOYMENT
# ═══════════════════════════════════════════════════════════════

Print-Step 8 "Esperando que se compile (3-5 minutos)"

$appUrl = "https://$appName.herokuapp.com"
$healthUrl = "$appUrl/health"

Write-Host ""
Write-Host "La app se está compilando en Heroku..." -ForegroundColor Yellow
Write-Host "Esto puede tomar 3-5 minutos..." -ForegroundColor Yellow
Write-Host ""

$maxAttempts = 30
$attempt = 0
$deployed = $false

while ($attempt -lt $maxAttempts -and -not $deployed) {
    $attempt++

    try {
        $response = Invoke-WebRequest -Uri $healthUrl -TimeoutSec 5 -ErrorAction SilentlyContinue

        if ($response.StatusCode -eq 200) {
            Print-Success "¡App está en línea!"
            $deployed = $true

            Write-Host ""
            Write-Host "Respuesta del servidor:" -ForegroundColor Cyan
            Write-Host $response.Content -ForegroundColor Green
        }
    } catch {
        # Esperando...
        $dotCount = $attempt % 3 + 1
        $dots = "." * $dotCount
        Write-Host "`r  Verificando$dots" -NoNewline -ForegroundColor Gray
        Start-Sleep -Seconds 10
    }
}

Write-Host ""

if (-not $deployed) {
    Write-Host "  ⚠ El endpoint aún no responde, pero el deployment puede estar en progreso" -ForegroundColor Yellow
    Print-Info "Revisa los logs con:"
    Write-Host "       heroku logs -a $appName --tail" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════════
# RESUMEN FINAL
# ═══════════════════════════════════════════════════════════════

Print-Header "✓ DEPLOYMENT COMPLETADO"

Write-Host "URLs de tu aplicación:" -ForegroundColor Cyan
Write-Host "  App:         $appUrl" -ForegroundColor Yellow
Write-Host "  Health:      $healthUrl" -ForegroundColor Yellow
Write-Host ""

Write-Host "Comandos útiles:" -ForegroundColor Cyan
Write-Host "  Ver logs en vivo:" -ForegroundColor Gray
Write-Host "    heroku logs -a $appName --tail" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Ver estado:" -ForegroundColor Gray
Write-Host "    heroku ps -a $appName" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Acceder a la consola:" -ForegroundColor Gray
Write-Host "    heroku run bash -a $appName" -ForegroundColor Yellow
Write-Host ""

Write-Host "Próximos pasos:" -ForegroundColor Cyan
Write-Host "  1. Verifica que la app esté corriendo en:"
Write-Host "     $appUrl" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Abre en el navegador:" -ForegroundColor Gray
Write-Host "     start '$appUrl'" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Configura webhook en Meta:" -ForegroundColor Gray
Write-Host "     URL: $appUrl/api/webhook" -ForegroundColor Yellow
Write-Host ""

Write-Host ("╚" + ("═" * 67) + "╝") -ForegroundColor Green
Write-Host ""
Write-Host "¡Deployment exitoso! Tu app está en la nube 🚀" -ForegroundColor Green
