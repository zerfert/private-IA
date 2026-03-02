#!/bin/bash
# ============================================================
# Script de Health Check para OpenClaw
# Ejecutar dentro de WSL2 (Ubuntu)
# ============================================================

echo "============================================"
echo "  OpenClaw - Health Check 🦞"
echo "============================================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "${GREEN}  ✅ $1${NC}"; ((PASS++)); }
check_warn() { echo -e "${YELLOW}  ⚠️  $1${NC}"; ((WARN++)); }
check_fail() { echo -e "${RED}  ❌ $1${NC}"; ((FAIL++)); }

# 1. Node.js
echo "== Node.js =="
if command -v node &> /dev/null; then
    NODE_VER=$(node --version | sed 's/v//' | cut -d'.' -f1)
    if [ "$NODE_VER" -ge 22 ]; then
        check_pass "Node.js $(node --version)"
    else
        check_fail "Node.js $(node --version) - Se requiere >= 22"
    fi
else
    check_fail "Node.js no instalado"
fi

# 2. npm
if command -v npm &> /dev/null; then
    check_pass "npm $(npm --version)"
else
    check_fail "npm no instalado"
fi

# 3. OpenClaw
echo ""
echo "== OpenClaw =="
if command -v openclaw &> /dev/null; then
    check_pass "OpenClaw instalado"
else
    check_fail "OpenClaw no instalado"
fi

# 4. Configuración
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ -f "$CONFIG_FILE" ]; then
    check_pass "Configuración encontrada: $CONFIG_FILE"
else
    check_fail "Configuración no encontrada: $CONFIG_FILE"
fi

# 5. API Keys
echo ""
echo "== API Keys =="
if [ -n "$ANTHROPIC_API_KEY" ]; then
    check_pass "ANTHROPIC_API_KEY configurada"
else
    check_warn "ANTHROPIC_API_KEY no configurada"
fi

if [ -n "$OPENAI_API_KEY" ]; then
    check_pass "OPENAI_API_KEY configurada"
else
    check_warn "OPENAI_API_KEY no configurada"
fi

# 6. Canales
echo ""
echo "== Canales =="
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    check_pass "TELEGRAM_BOT_TOKEN configurado"
else
    check_warn "TELEGRAM_BOT_TOKEN no configurado"
fi

if [ -n "$DISCORD_BOT_TOKEN" ]; then
    check_pass "DISCORD_BOT_TOKEN configurado"
else
    check_warn "DISCORD_BOT_TOKEN no configurado"
fi

# 7. Gateway
echo ""
echo "== Gateway =="
if curl -s http://localhost:18789 > /dev/null 2>&1; then
    check_pass "Gateway corriendo en puerto 18789"
else
    check_warn "Gateway no detectado en puerto 18789"
fi

# 8. Workspace
echo ""
echo "== Workspace =="
if [ -d "$HOME/.openclaw/workspace" ]; then
    check_pass "Workspace existe"
else
    check_fail "Workspace no encontrado"
fi

if [ -f "$HOME/.openclaw/workspace/AGENTS.md" ]; then
    check_pass "AGENTS.md configurado"
else
    check_warn "AGENTS.md no encontrado"
fi

# Resumen
echo ""
echo "============================================"
echo "  Resumen del Health Check"
echo "============================================"
echo -e "  ${GREEN}Pasaron: $PASS${NC}"
echo -e "  ${YELLOW}Advertencias: $WARN${NC}"
echo -e "  ${RED}Fallaron: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}  🦞 OpenClaw está listo para funcionar!${NC}"
else
    echo -e "${RED}  ⚠️ Hay $FAIL problemas que resolver.${NC}"
fi
echo ""
