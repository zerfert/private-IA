#!/bin/bash
# ============================================================
# Script de Backup de Configuración de OpenClaw
# Ejecutar dentro de WSL2 (Ubuntu)
# ============================================================

echo "============================================"
echo "  OpenClaw - Backup de Configuración"
echo "============================================"
echo ""

BACKUP_DIR="$HOME/openclaw-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

mkdir -p "$BACKUP_PATH"

echo "Creando backup en: $BACKUP_PATH"
echo ""

# Backup de configuración
if [ -f "$HOME/.openclaw/openclaw.json" ]; then
    cp "$HOME/.openclaw/openclaw.json" "$BACKUP_PATH/"
    echo "  ✅ openclaw.json"
fi

# Backup de workspace
if [ -d "$HOME/.openclaw/workspace" ]; then
    cp -r "$HOME/.openclaw/workspace" "$BACKUP_PATH/"
    echo "  ✅ workspace/"
fi

# Backup de credenciales
if [ -d "$HOME/.openclaw/credentials" ]; then
    cp -r "$HOME/.openclaw/credentials" "$BACKUP_PATH/"
    echo "  ✅ credentials/"
fi

# Backup de variables de entorno relevantes
echo "# OpenClaw Environment Variables Backup" > "$BACKUP_PATH/env_vars.sh"
echo "# Fecha: $(date)" >> "$BACKUP_PATH/env_vars.sh"
echo "" >> "$BACKUP_PATH/env_vars.sh"

if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\"" >> "$BACKUP_PATH/env_vars.sh"
fi
if [ -n "$OPENAI_API_KEY" ]; then
    echo "export OPENAI_API_KEY=\"$OPENAI_API_KEY\"" >> "$BACKUP_PATH/env_vars.sh"
fi
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    echo "export TELEGRAM_BOT_TOKEN=\"$TELEGRAM_BOT_TOKEN\"" >> "$BACKUP_PATH/env_vars.sh"
fi
if [ -n "$DISCORD_BOT_TOKEN" ]; then
    echo "export DISCORD_BOT_TOKEN=\"$DISCORD_BOT_TOKEN\"" >> "$BACKUP_PATH/env_vars.sh"
fi
echo "  ✅ env_vars.sh"

# Comprimir backup
echo ""
echo "Comprimiendo backup..."
cd "$BACKUP_DIR"
tar -czf "backup_$TIMESTAMP.tar.gz" "backup_$TIMESTAMP"
rm -rf "backup_$TIMESTAMP"

echo ""
echo "============================================"
echo "  ✅ Backup completado"
echo "  📁 Archivo: $BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
echo "============================================"
echo ""

# Listar backups existentes
echo "Backups disponibles:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "  No se encontraron backups previos"
echo ""
