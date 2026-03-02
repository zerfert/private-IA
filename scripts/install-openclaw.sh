#!/bin/bash
# ============================================================
# Script de Instalación de OpenClaw
# Ejecutar dentro de WSL2 (Ubuntu)
# ============================================================

set -e

echo "============================================"
echo "  OpenClaw - Instalación del Agente IA"
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

# Cargar NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 1. Verificar Node.js
info "[1/5] Verificando Node.js..."
NODE_VERSION=$(node --version 2>/dev/null | sed 's/v//' | cut -d'.' -f1)
if [ -z "$NODE_VERSION" ] || [ "$NODE_VERSION" -lt 22 ]; then
    error "Node.js >= 22 es requerido. Versión actual: $(node --version 2>/dev/null || echo 'no instalado')"
    echo "Ejecuta primero: bash scripts/install-nodejs.sh"
    exit 1
fi
success "Node.js $(node --version) detectado"

# 2. Instalar OpenClaw
info "[2/5] Instalando OpenClaw..."
if command -v openclaw &> /dev/null; then
    warn "OpenClaw ya está instalado. Actualizando..."
    npm install -g openclaw@latest
else
    npm install -g openclaw@latest
fi
success "OpenClaw $(openclaw --version 2>/dev/null || echo 'instalado') instalado"

# 3. Crear directorio de configuración
info "[3/5] Creando estructura de directorios..."
mkdir -p ~/.openclaw/workspace/skills
mkdir -p ~/.openclaw/credentials
mkdir -p ~/.openclaw/logs
success "Directorios creados"

# 4. Crear configuración base si no existe
info "[4/5] Verificando configuración..."
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
{
  "agent": {
    "model": "anthropic/claude-opus-4-6"
  },
  "gateway": {
    "port": 18789,
    "bind": "loopback"
  }
}
EOF
    success "Configuración base creada en $CONFIG_FILE"
    warn "Recuerda configurar tu API key. Ver: docs/06-configuracion-modelos.md"
else
    warn "Configuración ya existe. No se modificó."
fi

# 5. Verificar instalación
info "[5/5] Verificando instalación..."
echo ""
openclaw doctor 2>/dev/null || warn "openclaw doctor no disponible hasta configurar el modelo"

# Resumen
echo ""
echo "============================================"
echo -e "${CYAN}  OpenClaw instalado exitosamente 🦞${NC}"
echo "============================================"
echo ""
echo "Próximos pasos:"
echo ""
echo "  1. Configura tu API key:"
echo "     export ANTHROPIC_API_KEY=\"tu-api-key\""
echo "     # o"
echo "     export OPENAI_API_KEY=\"tu-api-key\""
echo ""
echo "  2. Ejecuta el asistente de configuración:"
echo "     openclaw onboard --install-daemon"
echo ""
echo "  3. O configura manualmente:"
echo "     bash scripts/setup-gateway.sh"
echo ""
echo "  Documentación: docs/"
echo ""
