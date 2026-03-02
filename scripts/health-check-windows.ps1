# ============================================================
# Health Check de OpenClaw para Windows Nativo
# Ejecutar en PowerShell
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OpenClaw - Health Check (Windows)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$pass = 0
$fail = 0
$warn = 0

function Check-Pass($msg) { Write-Host "  OK $msg" -ForegroundColor Green; $script:pass++ }
function Check-Fail($msg) { Write-Host "  FALLO $msg" -ForegroundColor Red; $script:fail++ }
function Check-Warn($msg) { Write-Host "  AVISO $msg" -ForegroundColor Yellow; $script:warn++ }

# == Node.js ==
Write-Host "== Node.js ==" -ForegroundColor White
try {
    $nodeVer = & node --version 2>$null
    $nodeMajor = [int]($nodeVer -replace 'v','').Split('.')[0]
    if ($nodeMajor -ge 22) {
        Check-Pass "Node.js $nodeVer"
    } else {
        Check-Fail "Node.js $nodeVer - Se requiere >= 22"
    }
} catch {
    Check-Fail "Node.js no instalado"
}

# npm
try {
    $npmVer = & npm --version 2>$null
    Check-Pass "npm $npmVer"
} catch {
    Check-Fail "npm no instalado"
}

# == OpenClaw ==
Write-Host ""
Write-Host "== OpenClaw ==" -ForegroundColor White
try {
    $ocVer = & openclaw --version 2>$null
    Check-Pass "OpenClaw $ocVer"
} catch {
    Check-Fail "OpenClaw no instalado"
}

# == Configuracion ==
Write-Host ""
Write-Host "== Configuracion ==" -ForegroundColor White
$configFile = "$env:USERPROFILE\.openclaw\openclaw.json"
if (Test-Path $configFile) {
    Check-Pass "Configuracion: $configFile"
} else {
    Check-Fail "Configuracion no encontrada: $configFile"
}

# == API Keys ==
Write-Host ""
Write-Host "== API Keys ==" -ForegroundColor White
if ($env:ANTHROPIC_API_KEY) {
    Check-Pass "ANTHROPIC_API_KEY configurada"
} else {
    # Verificar tambien variable de usuario
    $userKey = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User")
    if ($userKey) {
        Check-Pass "ANTHROPIC_API_KEY configurada (variable de usuario)"
    } else {
        Check-Warn "ANTHROPIC_API_KEY no configurada"
    }
}

if ($env:OPENAI_API_KEY) {
    Check-Pass "OPENAI_API_KEY configurada"
} else {
    $userKey = [System.Environment]::GetEnvironmentVariable("OPENAI_API_KEY", "User")
    if ($userKey) {
        Check-Pass "OPENAI_API_KEY configurada (variable de usuario)"
    } else {
        Check-Warn "OPENAI_API_KEY no configurada"
    }
}

# == Canales ==
Write-Host ""
Write-Host "== Canales ==" -ForegroundColor White
$telegramToken = $env:TELEGRAM_BOT_TOKEN
if (-not $telegramToken) { $telegramToken = [System.Environment]::GetEnvironmentVariable("TELEGRAM_BOT_TOKEN", "User") }
if ($telegramToken) { Check-Pass "TELEGRAM_BOT_TOKEN configurado" } else { Check-Warn "TELEGRAM_BOT_TOKEN no configurado" }

$discordToken = $env:DISCORD_BOT_TOKEN
if (-not $discordToken) { $discordToken = [System.Environment]::GetEnvironmentVariable("DISCORD_BOT_TOKEN", "User") }
if ($discordToken) { Check-Pass "DISCORD_BOT_TOKEN configurado" } else { Check-Warn "DISCORD_BOT_TOKEN no configurado" }

# == Gateway ==
Write-Host ""
Write-Host "== Gateway ==" -ForegroundColor White
try {
    $response = Invoke-WebRequest -Uri "http://localhost:18789" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
    Check-Pass "Gateway corriendo en puerto 18789"
} catch {
    Check-Warn "Gateway no detectado en puerto 18789"
}

# == Workspace ==
Write-Host ""
Write-Host "== Workspace ==" -ForegroundColor White
$workspaceDir = "$env:USERPROFILE\.openclaw\workspace"
if (Test-Path $workspaceDir) {
    Check-Pass "Workspace existe: $workspaceDir"
} else {
    Check-Fail "Workspace no encontrado"
}

$agentsFile = "$workspaceDir\AGENTS.md"
if (Test-Path $agentsFile) {
    Check-Pass "AGENTS.md configurado"
} else {
    Check-Warn "AGENTS.md no encontrado"
}

# == Resumen ==
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Resumen del Health Check" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Pasaron:       $pass" -ForegroundColor Green
Write-Host "  Advertencias:  $warn" -ForegroundColor Yellow
Write-Host "  Fallaron:      $fail" -ForegroundColor Red
Write-Host ""

if ($fail -eq 0) {
    Write-Host "  OpenClaw esta listo para funcionar!" -ForegroundColor Green
} else {
    Write-Host "  Hay $fail problema(s) que resolver." -ForegroundColor Red
}
Write-Host ""
