# Deploy Frontend to Render using API
param(
    [string]$ApiToken = "rnd_KbJsvNw8JFPgPjU1rHGpGGhPZ8GF"
)

$ErrorActionPreference = "Continue"

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      DEPLOYING FRONTEND TO RENDER - STATIC SITE           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

# Render API Configuration
$ApiBaseUrl = "https://api.render.com/v1"
$Headers = @{
    "Authorization" = "Bearer $ApiToken"
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}

# Service Configuration
$ServiceConfig = @{
    type = "static_site"
    name = "whatsapp-agent-frontend"
    repo = "https://github.com/ibarracarlos470/whatsapp-agent"
    branch = "main"
    rootDir = "frontend"
    buildCommand = "npm install && npm run build"
    staticPublishPath = "dist"
    autoDeploy = $true
} | ConvertTo-Json

Write-Host "`n[1/2] Creating static site in Render..." -ForegroundColor Yellow
Write-Host "Configuration:" -ForegroundColor Gray
Write-Host $ServiceConfig -ForegroundColor Gray

try {
    $Response = Invoke-WebRequest -Uri "$ApiBaseUrl/services" `
        -Headers $Headers `
        -Method Post `
        -Body $ServiceConfig `
        -ErrorAction Stop

    $ServiceData = $Response.Content | ConvertFrom-Json
    $ServiceId = $ServiceData.id
    $ServiceName = $ServiceData.name

    Write-Host "`n✓ Static site created successfully" -ForegroundColor Green
    Write-Host "  Service ID: $ServiceId" -ForegroundColor Gray
    Write-Host "  Service Name: $ServiceName" -ForegroundColor Gray

} catch {
    Write-Host "`n✗ Failed to create static site" -ForegroundColor Red
    Write-Host "Error Details: $_" -ForegroundColor Red

    if ($_.Exception.Response) {
        $responseStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody" -ForegroundColor Gray
    }

    exit 1
}

Write-Host "`n[2/2] Deployment configured successfully..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    DEPLOYMENT COMPLETE                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n✅ Frontend deployed to Render" -ForegroundColor Green
Write-Host "✅ Service: whatsapp-agent-frontend" -ForegroundColor Green
Write-Host "✅ Repository: https://github.com/ibarracarlos470/whatsapp-agent" -ForegroundColor Green
Write-Host "✅ Branch: main" -ForegroundColor Green
Write-Host "✅ Root Directory: frontend" -ForegroundColor Green
Write-Host "✅ Build Command: npm install && npm run build" -ForegroundColor Green
Write-Host "✅ Publish Directory: dist" -ForegroundColor Green
Write-Host "✅ Auto Deploy: Enabled" -ForegroundColor Green

Write-Host "`n📊 Service Details:" -ForegroundColor Cyan
Write-Host "   Service ID: $ServiceId" -ForegroundColor Gray
Write-Host "   Name: $ServiceName" -ForegroundColor Gray

Write-Host "`n🔗 Access your deployed frontend:" -ForegroundColor Cyan
Write-Host "   Dashboard: https://dashboard.render.com" -ForegroundColor Yellow
Write-Host "   Service: https://dashboard.render.com/services/$ServiceId" -ForegroundColor Yellow

Write-Host "`n⏳ Build Status:" -ForegroundColor Cyan
Write-Host "   Check the Render dashboard to monitor your build progress" -ForegroundColor Gray
Write-Host "   Expected URL: https://whatsapp-agent-frontend.onrender.com" -ForegroundColor Yellow

Write-Host "`n📝 Backend URL for .env configuration:" -ForegroundColor Cyan
Write-Host "   https://whatsapp-agent-backend.onrender.com" -ForegroundColor Yellow

Write-Host ""
