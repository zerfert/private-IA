#!/bin/bash
# ============================================================
# Script de Configuración del Gateway de OpenClaw
# Ejecutar dentro de WSL2 (Ubuntu)
# ============================================================

set -e

echo "============================================"
echo "  OpenClaw - Configuración del Gateway"
echo "============================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

success() { echo -e "${GREEN}  ✅ $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠️  $1${NC}"; }
error() { echo -e "${RED}  ❌ $1${NC}"; }
info() { echo -e "${YELLOW}$1${NC}"; }

CONFIG_FILE="$HOME/.openclaw/openclaw.json"

# 1. Verificar que OpenClaw está instalado
info "[1/6] Verificando instalación de OpenClaw..."
if ! command -v openclaw &> /dev/null; then
    error "OpenClaw no está instalado. Ejecuta primero: bash scripts/install-openclaw.sh"
    exit 1
fi
success "OpenClaw detectado"

# 2. Verificar API Key
info "[2/6] Verificando API Keys..."
API_CONFIGURED=false

if [ -n "$ANTHROPIC_API_KEY" ]; then
    success "ANTHROPIC_API_KEY configurada"
    API_CONFIGURED=true
fi

if [ -n "$OPENAI_API_KEY" ]; then
    success "OPENAI_API_KEY configurada"
    API_CONFIGURED=true
fi

if [ "$API_CONFIGURED" = false ]; then
    warn "No se detectó ninguna API key configurada."
    echo ""
    echo "¿Qué proveedor de IA deseas usar?"
    echo "  1) Anthropic (Claude) - Recomendado"
    echo "  2) OpenAI (GPT)"
    echo ""
    read -p "Selecciona (1/2): " provider_choice

    if [ "$provider_choice" = "1" ]; then
        read -p "Ingresa tu ANTHROPIC_API_KEY: " api_key
        export ANTHROPIC_API_KEY="$api_key"
        echo "export ANTHROPIC_API_KEY=\"$api_key\"" >> ~/.bashrc
        MODEL="anthropic/claude-opus-4-6"
        success "Anthropic API key configurada"
    elif [ "$provider_choice" = "2" ]; then
        read -p "Ingresa tu OPENAI_API_KEY: " api_key
        export OPENAI_API_KEY="$api_key"
        echo "export OPENAI_API_KEY=\"$api_key\"" >> ~/.bashrc
        MODEL="openai/gpt-4o"
        success "OpenAI API key configurada"
    else
        error "Opción no válida"
        exit 1
    fi
fi

# 3. Configurar canal de mensajería
info "[3/6] Configurando canal de mensajería..."
echo ""
echo "¿Qué canal de mensajería deseas configurar?"
echo "  1) Telegram"
echo "  2) Discord"
echo "  3) WhatsApp"
echo "  4) Ninguno por ahora"
echo ""
read -p "Selecciona (1/2/3/4): " channel_choice

CHANNEL_CONFIG=""

case $channel_choice in
    1)
        read -p "Ingresa tu TELEGRAM_BOT_TOKEN: " telegram_token
        read -p "Ingresa tu username de Telegram (sin @): " telegram_user
        export TELEGRAM_BOT_TOKEN="$telegram_token"
        echo "export TELEGRAM_BOT_TOKEN=\"$telegram_token\"" >> ~/.bashrc
        CHANNEL_CONFIG='"channels": {
    "telegram": {
      "botToken": "'"$telegram_token"'",
      "allowFrom": ["'"$telegram_user"'"],
      "dmPolicy": "pairing"
    }
  }'
        success "Telegram configurado"
        ;;
    2)
        read -p "Ingresa tu DISCORD_BOT_TOKEN: " discord_token
        read -p "Ingresa tu Discord User ID: " discord_user
        export DISCORD_BOT_TOKEN="$discord_token"
        echo "export DISCORD_BOT_TOKEN=\"$discord_token\"" >> ~/.bashrc
        CHANNEL_CONFIG='"channels": {
    "discord": {
      "token": "'"$discord_token"'",
      "allowFrom": ["'"$discord_user"'"],
      "dmPolicy": "pairing"
    }
  }'
        success "Discord configurado"
        ;;
    3)
        read -p "Ingresa tu número de WhatsApp con código de país (ej: +1234567890): " whatsapp_number
        CHANNEL_CONFIG='"channels": {
    "whatsapp": {
      "allowFrom": ["'"$whatsapp_number"'"],
      "dmPolicy": "pairing"
    }
  }'
        success "WhatsApp configurado (necesitarás vincular el dispositivo después)"
        ;;
    4)
        warn "Sin canal configurado. Puedes agregar uno después."
        ;;
    *)
        warn "Opción no reconocida. Continuando sin canal."
        ;;
esac

# 4. Generar configuración
info "[4/6] Generando archivo de configuración..."

MODEL=${MODEL:-"anthropic/claude-opus-4-6"}

if [ -n "$CHANNEL_CONFIG" ]; then
    cat > "$CONFIG_FILE" << EOF
{
  "agent": {
    "model": "$MODEL"
  },
  "gateway": {
    "port": 18789,
    "bind": "loopback"
  },
  $CHANNEL_CONFIG
}
EOF
else
    cat > "$CONFIG_FILE" << EOF
{
  "agent": {
    "model": "$MODEL"
  },
  "gateway": {
    "port": 18789,
    "bind": "loopback"
  }
}
EOF
fi

success "Configuración guardada en $CONFIG_FILE"

# 5. Crear AGENTS.md si no existe
info "[5/6] Configurando workspace del agente..."
AGENTS_FILE="$HOME/.openclaw/workspace/AGENTS.md"
if [ ! -f "$AGENTS_FILE" ]; then
    cat > "$AGENTS_FILE" << 'EOF'
# Mi Asistente Personal OpenClaw

Eres un asistente personal inteligente y servicial. 

## Directrices
- Responde siempre en español, a menos que el usuario hable en otro idioma
- Sé conciso pero completo en tus respuestas
- Si no sabes algo, dilo honestamente
- Ofrece alternativas cuando sea posible

## Áreas de Experiencia
- Productividad y organización
- Investigación y análisis
- Programación y tecnología
- Comunicación y redacción
EOF
    success "AGENTS.md creado"
else
    warn "AGENTS.md ya existe. No se modificó."
fi

# 6. Iniciar el gateway
info "[6/6] Iniciando el Gateway..."
echo ""
echo "¿Deseas iniciar el Gateway ahora?"
read -p "(s/n): " start_choice

if [ "$start_choice" = "s" ] || [ "$start_choice" = "S" ]; then
    if [ "$channel_choice" = "3" ]; then
        echo ""
        warn "Para WhatsApp, primero debes vincular tu dispositivo:"
        echo "  openclaw channels login"
        echo ""
        echo "Después inicia el gateway:"
        echo "  openclaw gateway --port 18789 --verbose"
    else
        echo ""
        echo "Iniciando gateway en modo verbose..."
        echo "Presiona Ctrl+C para detener."
        echo ""
        openclaw gateway --port 18789 --verbose
    fi
else
    echo ""
    echo "Para iniciar el gateway después, ejecuta:"
    echo "  openclaw gateway --port 18789 --verbose"
    echo ""
    echo "O como daemon (segundo plano):"
    echo "  openclaw gateway start"
fi

echo ""
echo "============================================"
echo -e "${CYAN}  Gateway configurado exitosamente 🦞${NC}"
echo "============================================"
echo ""
