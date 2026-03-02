# 03 - Instalación de Node.js

## Requisito

OpenClaw requiere **Node.js ≥ 22** (versión LTS recomendada).

## Instalación con NVM (Recomendado)

NVM (Node Version Manager) permite gestionar múltiples versiones de Node.js.

### Instalación Automática
```bash
bash scripts/install-nodejs.sh
```

### Instalación Manual

1. **Instalar NVM:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

2. **Recargar el perfil:**
```bash
source ~/.bashrc
```

3. **Instalar Node.js 22 LTS:**
```bash
nvm install 22
nvm use 22
nvm alias default 22
```

4. **Verificar la instalación:**
```bash
node --version   # Debería mostrar v22.x.x
npm --version    # Debería mostrar 10.x.x
```

## Instalar pnpm (Opcional pero Recomendado)

pnpm es más rápido y eficiente que npm:

```bash
npm install -g pnpm
pnpm --version
```

## Verificación Completa

```bash
echo "=== Verificación de Node.js ==="
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "pnpm: $(pnpm --version 2>/dev/null || echo 'no instalado')"
echo "nvm: $(nvm --version)"
echo "================================"
```

## Siguiente Paso
→ [04 - Instalación de OpenClaw](04-instalacion-openclaw.md)
