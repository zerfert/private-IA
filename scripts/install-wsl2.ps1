# ============================================================
# Script de Instalación de WSL2 para OpenClaw
# Ejecutar como Administrador en PowerShell
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OpenClaw - Instalación de WSL2" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Este script debe ejecutarse como Administrador." -ForegroundColor Red
    Write-Host "Haz clic derecho en PowerShell y selecciona 'Ejecutar como administrador'." -ForegroundColor Yellow
    exit 1
}

# Verificar versión de Windows
$osVersion = [System.Environment]::OSVersion.Version
Write-Host "[1/6] Verificando versión de Windows..." -ForegroundColor Yellow
if ($osVersion.Build -ge 22000) {
    Write-Host "  ✅ Windows 11 (Build $($osVersion.Build)) - Compatible" -ForegroundColor Green
} elseif ($osVersion.Build -ge 19041) {
    Write-Host "  ✅ Windows 10 (Build $($osVersion.Build)) - Compatible con WSL2" -ForegroundColor Green
} else {
    Write-Host "  ❌ Build $($osVersion.Build) no es compatible con WSL2. Necesitas Build 19041+." -ForegroundColor Red
    exit 1
}

# Verificar virtualización
Write-Host "[2/6] Verificando virtualización de hardware..." -ForegroundColor Yellow
try {
    $virtEnabled = (Get-ComputerInfo -Property "HyperVRequirementVirtualizationFirmwareEnabled").HyperVRequirementVirtualizationFirmwareEnabled
    if ($virtEnabled) {
        Write-Host "  ✅ Virtualización habilitada" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Virtualización no detectada. Puede que necesites habilitarla en el BIOS." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠️  No se pudo verificar la virtualización. Continuando..." -ForegroundColor Yellow
}

# Habilitar características de Windows
Write-Host "[3/6] Habilitando características de Windows..." -ForegroundColor Yellow

Write-Host "  Habilitando Microsoft-Windows-Subsystem-Linux..." -ForegroundColor Gray
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | Out-Null

Write-Host "  Habilitando VirtualMachinePlatform..." -ForegroundColor Gray
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart | Out-Null

Write-Host "  ✅ Características habilitadas" -ForegroundColor Green

# Instalar WSL
Write-Host "[4/6] Instalando WSL2..." -ForegroundColor Yellow
wsl --install --no-distribution 2>$null
wsl --set-default-version 2
Write-Host "  ✅ WSL2 configurado como versión por defecto" -ForegroundColor Green

# Instalar Ubuntu
Write-Host "[5/6] Instalando Ubuntu 22.04..." -ForegroundColor Yellow
wsl --install -d Ubuntu-22.04
Write-Host "  ✅ Ubuntu 22.04 instalado" -ForegroundColor Green

# Crear archivo .wslconfig
Write-Host "[6/6] Creando configuración optimizada de WSL2..." -ForegroundColor Yellow
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
$wslConfig = @"
[wsl2]
memory=4GB
processors=2
swap=2GB
localhostForwarding=true
"@

if (-not (Test-Path $wslConfigPath)) {
    $wslConfig | Out-File -FilePath $wslConfigPath -Encoding utf8
    Write-Host "  ✅ Archivo .wslconfig creado en $wslConfigPath" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  .wslconfig ya existe. No se modificó." -ForegroundColor Yellow
}

# Resumen
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Instalación de WSL2 completada" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANTE: Reinicia Windows para completar la instalación." -ForegroundColor Yellow
Write-Host ""
Write-Host "Después del reinicio:" -ForegroundColor White
Write-Host "  1. Abre Ubuntu desde el menú de inicio" -ForegroundColor White
Write-Host "  2. Crea un usuario y contraseña" -ForegroundColor White
Write-Host "  3. Ejecuta: bash scripts/install-nodejs.sh" -ForegroundColor White
Write-Host ""

$restart = Read-Host "¿Deseas reiniciar ahora? (s/n)"
if ($restart -eq "s" -or $restart -eq "S") {
    Restart-Computer
}
