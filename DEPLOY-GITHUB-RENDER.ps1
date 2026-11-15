# DEPLOY A GITHUB + RENDER - COMPLETAMENTE AUTOMATIZADO

$env:Path += ";C:\Program Files\Git\cmd"

cd "C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent"

Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  GITHUB + RENDER DEPLOYMENT - AUTOMATIZADO           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 1. CONFIGURAR GIT LOCALMENTE
Write-Host "1️⃣ Configurando Git..." -ForegroundColor Yellow
git init
git config user.name "ibarracarlos470"
git config user.email "ibarracarlos470@gmail.com"
git add .
git commit -m "WhatsApp Agent - Ready for Production"

# 2. CREAR REPOSITORIO EN GITHUB VIA API
Write-Host ""
Write-Host "2️⃣ Necesito tu GitHub token para crear el repositorio..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Para obtener tu token:" -ForegroundColor Green
Write-Host "  1. Ve a: https://github.com/settings/tokens"
Write-Host "  2. Click 'Generate new token'"
Write-Host "  3. Selecciona scope: repo (full control)"
Write-Host "  4. Copia el token"
Write-Host ""

$githubToken = Read-Host "Pega tu GitHub token aquí"

if ([string]::IsNullOrEmpty($githubToken)) {
    Write-Host "❌ Token requerido. Abortando." -ForegroundColor Red
    exit
}

# 3. CREAR REPO EN GITHUB VIA API
Write-Host ""
Write-Host "3️⃣ Creando repositorio en GitHub..." -ForegroundColor Yellow

$repoName = "whatsapp-agent"
$apiUrl = "https://api.github.com/user/repos"

$repoData = @{
    name = $repoName
    description = "WhatsApp AI Customer Service Agent - SaaS"
    private = $false
    auto_init = $false
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $githubToken"
    "Accept" = "application/vnd.github.v3+json"
}

try {
    $response = Invoke-WebRequest -Uri $apiUrl -Method POST -Headers $headers -Body $repoData -ContentType "application/json"
    Write-Host "✅ Repositorio creado en GitHub" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "⚠️ Repositorio ya existe" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Error creando repositorio: $_" -ForegroundColor Red
    }
}

# 4. AGREGAR REMOTO Y PUSHEAR
Write-Host ""
Write-Host "4️⃣ Pusheando código a GitHub..." -ForegroundColor Yellow

$githubUsername = "ibarracarlos470"
git remote add origin "https://github.com/$githubUsername/$repoName.git" 2>$null
git branch -M main
git push -u origin main --force

Write-Host "✅ Código en GitHub" -ForegroundColor Green

# 5. GENERAR LINK DE RENDER
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✅ GITHUB COMPLETO                      ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

$renderLink = "https://render.com/deploy?repo=https://github.com/$githubUsername/$repoName"

Write-Host "📍 TU REPOSITORIO:" -ForegroundColor Cyan
Write-Host "   https://github.com/$githubUsername/$repoName" -ForegroundColor Green
Write-Host ""

Write-Host "🚀 DEPLOY EN RENDER (CLICK EN EL LINK):" -ForegroundColor Cyan
Write-Host "   $renderLink" -ForegroundColor Green
Write-Host ""

Write-Host "AHORA:" -ForegroundColor Yellow
Write-Host "  1. Abre el link arriba" -ForegroundColor Yellow
Write-Host "  2. Conecta tu GitHub" -ForegroundColor Yellow
Write-Host "  3. Configura variables de entorno" -ForegroundColor Yellow
Write-Host "  4. Click 'Deploy'" -ForegroundColor Yellow
Write-Host "  5. ¡ESPERA 10 MINUTOS!" -ForegroundColor Yellow
Write-Host ""

# ABRIR RENDER EN NAVEGADOR
Start-Process $renderLink

Write-Host "✨ Navegador abierto con Render..." -ForegroundColor Cyan
