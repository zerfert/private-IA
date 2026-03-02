# ============================================================
# Backup de Configuracion de OpenClaw para Windows
# Ejecutar en PowerShell
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OpenClaw - Backup de Configuracion" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "$env:USERPROFILE\openclaw-backups"
$backupPath = "$backupDir\backup_$timestamp"

# Crear directorio de backup
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

Write-Host "Creando backup en: $backupPath" -ForegroundColor White
Write-Host ""

$openclawDir = "$env:USERPROFILE\.openclaw"

# Backup de configuracion
$configFile = "$openclawDir\openclaw.json"
if (Test-Path $configFile) {
    Copy-Item $configFile -Destination $backupPath
    Write-Host "  OK openclaw.json" -ForegroundColor Green
}

# Backup de workspace
$workspaceDir = "$openclawDir\workspace"
if (Test-Path $workspaceDir) {
    Copy-Item $workspaceDir -Destination "$backupPath\workspace" -Recurse
    Write-Host "  OK workspace/" -ForegroundColor Green
}

# Backup de credenciales
$credentialsDir = "$openclawDir\credentials"
if (Test-Path $credentialsDir) {
    Copy-Item $credentialsDir -Destination "$backupPath\credentials" -Recurse
    Write-Host "  OK credentials/" -ForegroundColor Green
}

# Backup de variables de entorno
$envFile = "$backupPath\env_vars.ps1"
$envContent = @"
# OpenClaw Environment Variables Backup
# Fecha: $(Get-Date)

"@

$anthropicKey = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User")
if ($anthropicKey) {
    $envContent += "`n[System.Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', '$anthropicKey', 'User')"
}

$openaiKey = [System.Environment]::GetEnvironmentVariable("OPENAI_API_KEY", "User")
if ($openaiKey) {
    $envContent += "`n[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', '$openaiKey', 'User')"
}

$telegramToken = [System.Environment]::GetEnvironmentVariable("TELEGRAM_BOT_TOKEN", "User")
if ($telegramToken) {
    $envContent += "`n[System.Environment]::SetEnvironmentVariable('TELEGRAM_BOT_TOKEN', '$telegramToken', 'User')"
}

$discordToken = [System.Environment]::GetEnvironmentVariable("DISCORD_BOT_TOKEN", "User")
if ($discordToken) {
    $envContent += "`n[System.Environment]::SetEnvironmentVariable('DISCORD_BOT_TOKEN', '$discordToken', 'User')"
}

$envContent | Out-File -FilePath $envFile -Encoding utf8
Write-Host "  OK env_vars.ps1" -ForegroundColor Green

# Comprimir backup
Write-Host ""
Write-Host "Comprimiendo backup..." -ForegroundColor Yellow
$zipFile = "$backupDir\backup_$timestamp.zip"
Compress-Archive -Path $backupPath -DestinationPath $zipFile
Remove-Item $backupPath -Recurse -Force

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OK Backup completado" -ForegroundColor Green
Write-Host "  Archivo: $zipFile" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Listar backups existentes
Write-Host "Backups disponibles:" -ForegroundColor White
Get-ChildItem "$backupDir\*.zip" | ForEach-Object {
    Write-Host "  $($_.Name)  ($([math]::Round($_.Length / 1KB, 1)) KB)" -ForegroundColor Gray
}
Write-Host ""
