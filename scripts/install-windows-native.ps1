# ============================================================
# Script de Instalación de OpenClaw NATIVO en Windows
# Ejecutar en PowerShell (NO requiere Administrador)
# NO requiere WSL2 ni virtualización
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OpenClaw - Instalacion Nativa en Windows" -ForegroundColor Cyan
Write-Host "  (Sin WSL2 - Sin Virtualizacion)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# -----------------------------------------------
# 1. Verificar Node.js
# -----------------------------------------------
Write-Host "[1/5] Verificando Node.js..." -ForegroundColor Yellow

$nodeInstalled = $false
try {
    $nodeVersion = & node --version 2>$null
    $nodeMajor = [int]($nodeVersion -replace 'v','').Split('.')[0]
    if ($nodeMajor -ge 22) {
        Write-Host "  OK Node.js $nodeVersion detectado" -ForegroundColor Green
        $nodeInstalled = $true
    } else {
        Write-Host "  AVISO Node.js $nodeVersion detectado, pero se requiere >= 22" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  Node.js no encontrado." -ForegroundColor Yellow
}

if (-not $nodeInstalled) {
    Write-Host ""
    Write-Host "  Node.js >= 22 es requerido. Opciones de instalacion:" -ForegroundColor White
    Write-Host "    1) Instalar con winget (recomendado)" -ForegroundColor White
    Write-Host "    2) Descargar desde https://nodejs.org/" -ForegroundColor White
    Write-Host "    3) Ya lo instale, continuar" -ForegroundColor White
    Write-Host ""
    $nodeChoice = Read-Host "  Selecciona (1/2/3)"

    switch ($nodeChoice) {
        "1" {
            Write-Host "  Instalando Node.js 22 con winget..." -ForegroundColor Gray
            winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
            Write-Host ""
            Write-Host "  IMPORTANTE: Cierra y vuelve a abrir PowerShell, luego ejecuta este script de nuevo." -ForegroundColor Yellow
            Write-Host ""
            exit 0
        }
        "2" {
            Start-Process "https://nodejs.org/"
            Write-Host "  Se abrio el navegador. Descarga e instala Node.js 22 LTS." -ForegroundColor White
            Write-Host "  Luego cierra y vuelve a abrir PowerShell y ejecuta este script de nuevo." -ForegroundColor Yellow
            exit 0
        }
        "3" {
            Write-Host "  Continuando..." -ForegroundColor Gray
        }
        default {
            Write-Host "  Opcion no valida. Saliendo." -ForegroundColor Red
            exit 1
        }
    }

    # Re-verificar
    try {
        $nodeVersion = & node --version 2>$null
        $nodeMajor = [int]($nodeVersion -replace 'v','').Split('.')[0]
        if ($nodeMajor -ge 22) {
            Write-Host "  OK Node.js $nodeVersion detectado" -ForegroundColor Green
        } else {
            Write-Host "  ERROR Node.js $nodeVersion no cumple requisito >= 22" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "  ERROR Node.js sigue sin detectarse. Reinicia PowerShell e intenta de nuevo." -ForegroundColor Red
        exit 1
    }
}

# -----------------------------------------------
# 2. Instalar OpenClaw
# -----------------------------------------------
Write-Host "[2/5] Instalando OpenClaw..." -ForegroundColor Yellow

try {
    $openclawVersion = & openclaw --version 2>$null
    Write-Host "  OpenClaw ya instalado ($openclawVersion). Actualizando..." -ForegroundColor Yellow
    npm install -g openclaw@latest
} catch {
    Write-Host "  Instalando OpenClaw globalmente..." -ForegroundColor Gray
    npm install -g openclaw@latest
}

try {
    $openclawVersion = & openclaw --version 2>$null
    Write-Host "  OK OpenClaw $openclawVersion instalado" -ForegroundColor Green
} catch {
    Write-Host "  ERROR No se pudo verificar OpenClaw. Intenta reiniciar PowerShell." -ForegroundColor Red
    exit 1
}

# -----------------------------------------------
# 3. Configurar API Key
# -----------------------------------------------
Write-Host "[3/5] Configurando modelo de IA..." -ForegroundColor Yellow

$geminiKey = $env:GEMINI_API_KEY
$anthropicKey = $env:ANTHROPIC_API_KEY
$openaiKey = $env:OPENAI_API_KEY
$apiConfigured = ($null -ne $geminiKey -and $geminiKey -ne "") -or ($null -ne $anthropicKey -and $anthropicKey -ne "") -or ($null -ne $openaiKey -and $openaiKey -ne "")

if ($apiConfigured) {
    if ($geminiKey) { Write-Host "  OK GEMINI_API_KEY ya configurada" -ForegroundColor Green }
    if ($anthropicKey) { Write-Host "  OK ANTHROPIC_API_KEY ya configurada" -ForegroundColor Green }
    if ($openaiKey) { Write-Host "  OK OPENAI_API_KEY ya configurada" -ForegroundColor Green }
} else {
    Write-Host ""
    Write-Host "  Que proveedor de IA deseas usar?" -ForegroundColor White
    Write-Host "    1) Google Gemini (Gemini 2.5 Flash) - Recomendado" -ForegroundColor White
    Write-Host "    2) Anthropic (Claude)" -ForegroundColor White
    Write-Host "    3) OpenAI (GPT-4o)" -ForegroundColor White
    Write-Host "    4) Configurar despues" -ForegroundColor White
    Write-Host ""
    $providerChoice = Read-Host "  Selecciona (1/2/3/4)"

    switch ($providerChoice) {
        "1" {
            $apiKey = Read-Host "  Ingresa tu GEMINI_API_KEY"
            if ($apiKey -ne "") {
                [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $apiKey, "User")
                $env:GEMINI_API_KEY = $apiKey
                Write-Host "  OK API key de Gemini configurada (permanente)" -ForegroundColor Green
            }
        }
        "2" {
            $apiKey = Read-Host "  Ingresa tu ANTHROPIC_API_KEY"
            if ($apiKey -ne "") {
                [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")
                $env:ANTHROPIC_API_KEY = $apiKey
                Write-Host "  OK API key de Anthropic configurada (permanente)" -ForegroundColor Green
            }
        }
        "3" {
            $apiKey = Read-Host "  Ingresa tu OPENAI_API_KEY"
            if ($apiKey -ne "") {
                [System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $apiKey, "User")
                $env:OPENAI_API_KEY = $apiKey
                Write-Host "  OK API key de OpenAI configurada (permanente)" -ForegroundColor Green
            }
        }
        "4" {
            Write-Host "  AVISO Recuerda configurar la API key antes de usar OpenClaw." -ForegroundColor Yellow
        }
    }
}

# -----------------------------------------------
# 4. Crear configuracion base
# -----------------------------------------------
Write-Host "[4/5] Creando configuracion..." -ForegroundColor Yellow

$openclawDir = "$env:USERPROFILE\.openclaw"
$configFile = "$openclawDir\openclaw.json"
$workspaceDir = "$openclawDir\workspace"

# Crear directorios
if (-not (Test-Path $openclawDir)) { New-Item -ItemType Directory -Path $openclawDir -Force | Out-Null }
if (-not (Test-Path "$openclawDir\credentials")) { New-Item -ItemType Directory -Path "$openclawDir\credentials" -Force | Out-Null }
if (-not (Test-Path "$openclawDir\logs")) { New-Item -ItemType Directory -Path "$openclawDir\logs" -Force | Out-Null }
if (-not (Test-Path $workspaceDir)) { New-Item -ItemType Directory -Path $workspaceDir -Force | Out-Null }
if (-not (Test-Path "$workspaceDir\skills")) { New-Item -ItemType Directory -Path "$workspaceDir\skills" -Force | Out-Null }

# Determinar modelo
$model = "google/gemini-2.5-flash"
$modelAlias = "flash"
if ($providerChoice -eq "2") { 
    $model = "anthropic/claude-opus-4-6"
    $modelAlias = "opus"
}
if ($providerChoice -eq "3") { 
    $model = "openai/gpt-4o"
    $modelAlias = "gpt4o"
}

# Configurar canal de mensajeria
Write-Host ""
Write-Host "  Que canal de mensajeria deseas configurar?" -ForegroundColor White
Write-Host "    1) Telegram" -ForegroundColor White
Write-Host "    2) Discord" -ForegroundColor White
Write-Host "    3) WhatsApp" -ForegroundColor White
Write-Host "    4) Ninguno por ahora" -ForegroundColor White
Write-Host ""
$channelChoice = Read-Host "  Selecciona (1/2/3/4)"

$channelConfig = ""

switch ($channelChoice) {
    "1" {
        $telegramToken = Read-Host "  Ingresa tu TELEGRAM_BOT_TOKEN"
        $telegramUser = Read-Host "  Ingresa tu username de Telegram (sin @)"
        if ($telegramToken -ne "") {
            [System.Environment]::SetEnvironmentVariable("TELEGRAM_BOT_TOKEN", $telegramToken, "User")
            $env:TELEGRAM_BOT_TOKEN = $telegramToken
            $channelConfig = @"
,
    "telegram": {
      "botToken": "$telegramToken",
      "allowFrom": ["$telegramUser"],
      "dmPolicy": "pairing"
    }
"@
            Write-Host "  OK Telegram configurado" -ForegroundColor Green
        }
    }
    "2" {
        $discordToken = Read-Host "  Ingresa tu DISCORD_BOT_TOKEN"
        $discordUser = Read-Host "  Ingresa tu Discord User ID"
        if ($discordToken -ne "") {
            [System.Environment]::SetEnvironmentVariable("DISCORD_BOT_TOKEN", $discordToken, "User")
            $env:DISCORD_BOT_TOKEN = $discordToken
            $channelConfig = @"
,
    "discord": {
      "token": "$discordToken",
      "allowFrom": ["$discordUser"],
      "dmPolicy": "pairing"
    }
"@
            Write-Host "  OK Discord configurado" -ForegroundColor Green
        }
    }
    "3" {
        $whatsappNumber = Read-Host "  Ingresa tu numero de WhatsApp (+codigo pais, ej: +1234567890)"
        $channelConfig = @"
,
    "whatsapp": {
      "allowFrom": ["$whatsappNumber"],
      "dmPolicy": "pairing"
    }
"@
        Write-Host "  OK WhatsApp configurado (necesitaras vincular dispositivo despues)" -ForegroundColor Green
    }
    "4" {
        Write-Host "  AVISO Sin canal configurado. Puedes agregar uno despues." -ForegroundColor Yellow
    }
}

# Escribir configuracion (formato v2026.3+)
if (-not (Test-Path $configFile)) {
    $config = @"
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "$model",
        "fallbacks": []
      },
      "models": {
        "$model": {
          "alias": "$modelAlias"
        }
      }
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback"
  },
  "channels": {$channelConfig
  },
  "tools": {}
}
"@
    $config | Out-File -FilePath $configFile -Encoding utf8
    Write-Host "  OK Configuracion creada en $configFile" -ForegroundColor Green
} else {
    Write-Host "  AVISO Configuracion ya existe. No se modifico." -ForegroundColor Yellow
    Write-Host "  Editar manualmente: $configFile" -ForegroundColor Gray
}

# Crear AGENTS.md
$agentsFile = "$workspaceDir\AGENTS.md"
if (-not (Test-Path $agentsFile)) {
    $agentsContent = @"
# Mi Asistente Personal OpenClaw

Eres un asistente personal inteligente y servicial.

## Directrices
- Responde siempre en espanol, a menos que el usuario hable en otro idioma
- Se conciso pero completo en tus respuestas
- Si no sabes algo, dilo honestamente
- Ofrece alternativas cuando sea posible

## Areas de Experiencia
- Productividad y organizacion
- Investigacion y analisis
- Programacion y tecnologia
- Comunicacion y redaccion
"@
    $agentsContent | Out-File -FilePath $agentsFile -Encoding utf8
    Write-Host "  OK AGENTS.md creado" -ForegroundColor Green
}

# -----------------------------------------------
# 5. Verificar y lanzar
# -----------------------------------------------
Write-Host "[5/5] Verificacion final..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Node.js:   $(node --version)" -ForegroundColor White
Write-Host "  npm:       $(npm --version)" -ForegroundColor White

try {
    $ocVer = & openclaw --version 2>$null
    Write-Host "  OpenClaw:  $ocVer" -ForegroundColor White
} catch {
    Write-Host "  OpenClaw:  instalado" -ForegroundColor White
}

Write-Host "  Config:    $configFile" -ForegroundColor White
Write-Host "  Workspace: $workspaceDir" -ForegroundColor White
Write-Host ""

# Resumen
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  OpenClaw instalado exitosamente! " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if ($channelChoice -eq "3") {
    Write-Host "NOTA: Para WhatsApp, primero vincula tu dispositivo:" -ForegroundColor Yellow
    Write-Host "  openclaw channels login" -ForegroundColor White
    Write-Host ""
}

Write-Host "Para iniciar el Gateway:" -ForegroundColor White
Write-Host "  openclaw gateway --port 18789 --verbose" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para usar el asistente de configuracion guiada:" -ForegroundColor White
Write-Host "  openclaw onboard --install-daemon" -ForegroundColor Cyan
Write-Host ""
Write-Host "UI de control: http://localhost:18789" -ForegroundColor White
Write-Host ""

$startNow = Read-Host "Deseas iniciar el Gateway ahora? (s/n)"
if ($startNow -eq "s" -or $startNow -eq "S") {
    Write-Host ""
    Write-Host "Iniciando Gateway... (Presiona Ctrl+C para detener)" -ForegroundColor Green
    Write-Host ""
    openclaw gateway --port 18789 --verbose
}
