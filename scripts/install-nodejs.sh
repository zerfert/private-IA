#!/bin/bash
# ============================================================
# Script de Instalación de Node.js para OpenClaw
# Ejecutar dentro de WSL2 (Ubuntu)
# ============================================================

set -e

echo "============================================"
echo "  OpenClaw - Instalación de Node.js"
echo "============================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para imprimir con color
success() { echo -e "${GREEN}  ✅ $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠️  $1${NC}"; }
error() { echo -e "${RED}  ❌ $1${NC}"; }
info() { echo -e "${YELLOW}$1${NC}"; }

# 1. Actualizar sistema
info "[1/5] Actualizando sistema..."
sudo apt update -qq && sudo apt upgrade -y -qq
success "Sistema actualizado"

# 2. Instalar dependencias
info "[2/5] Instalando dependencias..."
sudo apt install -y -qq curl wget git build-essential
success "Dependencias instaladas"

# 3. Instalar NVM
info "[3/5] Instalando NVM (Node Version Manager)..."
if [ -d "$HOME/.nvm" ]; then
    warn "NVM ya está instalado"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    success "NVM instalado"
fi

# Cargar NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 4. Instalar Node.js 22
info "[4/5] Instalando Node.js 22 LTS..."
nvm install 22
nvm use 22
nvm alias default 22
success "Node.js $(node --version) instalado"

# 5. Instalar pnpm
info "[5/5] Instalando pnpm..."
npm install -g pnpm
success "pnpm $(pnpm --version) instalado"

# Resumen
echo ""
echo "============================================"
echo -e "${CYAN}  Instalación de Node.js completada${NC}"
echo "============================================"
echo ""
echo "  Node.js: $(node --version)"
echo "  npm:     $(npm --version)"
echo "  pnpm:    $(pnpm --version)"
echo "  nvm:     $(nvm --version)"
echo ""
echo "Siguiente paso:"
echo "  bash scripts/install-openclaw.sh"
echo ""
