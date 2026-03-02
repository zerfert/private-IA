# 🦞 OpenClaw AI Agent - Instalación y Configuración en Windows

## Descripción del Proyecto

Este proyecto contiene todos los scripts, documentación y configuraciones necesarios para instalar y configurar **OpenClaw** (el agente de IA personal open-source, anteriormente conocido como Clawdbot/Moltbot) en un PC con Windows 11.

## Alcance del Trabajo

1. ✅ Instalar OpenClaw en Windows (vía WSL2 o setup nativo)
2. ✅ Configurar Node.js y todas las dependencias requeridas
3. ✅ Configurar el gateway y conectarlo a un modelo de IA (Claude u OpenAI)
4. ✅ Configurar al menos una integración de mensajería (WhatsApp, Telegram o Discord)
5. ✅ Guía de uso básico y configuración
6. ✅ Soporte continuo limitado para troubleshooting

## Requisitos Previos

- Windows 11
- Acceso a internet
- Cuenta de OpenAI o Anthropic (Claude)
- (Opcional) Cuenta de Telegram/Discord/WhatsApp para integración de canales

## Estructura del Proyecto

```
private-IA/
├── README.md                              # Este archivo
├── docs/
│   ├── 01-prerequisitos.md                # Requisitos previos del sistema
│   ├── 02-instalacion-wsl2.md             # Guía de instalación de WSL2
│   ├── 03-instalacion-nodejs.md           # Instalación de Node.js
│   ├── 04-instalacion-openclaw.md         # Instalación de OpenClaw
│   ├── 05-configuracion-gateway.md        # Configuración del Gateway
│   ├── 06-configuracion-modelos.md        # Configuración de modelos IA
│   ├── 07-integracion-telegram.md         # Integración con Telegram
│   ├── 08-integracion-discord.md          # Integración con Discord
│   ├── 09-integracion-whatsapp.md         # Integración con WhatsApp
│   ├── 10-uso-basico.md                   # Guía de uso básico
│   ├── 11-troubleshooting.md              # Resolución de problemas
│   └── 12-instalacion-nativa-windows.md   # ⭐ Instalación NATIVA (sin WSL2)
├── scripts/
│   ├── install-windows-native.ps1         # ⭐ Script TODO-EN-UNO para Windows nativo
│   ├── health-check-windows.ps1           # ⭐ Health check para Windows nativo
│   ├── backup-config-windows.ps1          # ⭐ Backup para Windows nativo
│   ├── install-wsl2.ps1                   # Script PowerShell para instalar WSL2
│   ├── install-nodejs.sh                  # Script para instalar Node.js en WSL2
│   ├── install-openclaw.sh                # Script para instalar OpenClaw en WSL2
│   ├── setup-gateway.sh                   # Script para configurar el Gateway en WSL2
│   ├── health-check.sh                    # Script de verificación de salud (WSL2)
│   └── backup-config.sh                   # Script para backup de configuración (WSL2)
├── config/
│   ├── openclaw.example.json              # Configuración de ejemplo de OpenClaw
│   ├── telegram.example.json              # Configuración de ejemplo para Telegram
│   ├── discord.example.json               # Configuración de ejemplo para Discord
│   └── whatsapp.example.json              # Configuración de ejemplo para WhatsApp
└── propuesta/
    └── propuesta-upwork.md                # Propuesta para el cliente de Upwork
```

## Inicio Rápido

### ⭐ Opción A: Instalación NATIVA en Windows (Recomendada - Sin WSL2)

No requiere virtualización ni WSL2. Solo necesitas Node.js ≥ 22.

```powershell
# Un solo script que hace todo:
.\scripts\install-windows-native.ps1
```

O manualmente:
```powershell
# 1. Instalar Node.js 22 (si no lo tienes)
winget install OpenJS.NodeJS.LTS

# 2. Instalar OpenClaw
npm install -g openclaw@latest

# 3. Configurar con el asistente guiado
openclaw onboard --install-daemon

# 4. O iniciar directamente
openclaw gateway --port 18789 --verbose
```

📖 Guía completa: [docs/12-instalacion-nativa-windows.md](docs/12-instalacion-nativa-windows.md)

---

### Opción B: Instalación con WSL2 (Linux en Windows)

Requiere virtualización habilitada en BIOS. Más potente para uso avanzado.

```powershell
# 1. Instalar WSL2 (PowerShell como Administrador)
.\scripts\install-wsl2.ps1
```

```bash
# 2. Instalar Node.js en WSL2
bash scripts/install-nodejs.sh

# 3. Instalar OpenClaw
bash scripts/install-openclaw.sh

# 4. Configurar y ejecutar
bash scripts/setup-gateway.sh
```

## Enlaces Importantes

- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Documentación Oficial](https://docs.openclaw.ai/)
- [Guía de Windows (WSL2)](https://docs.openclaw.ai/platforms/windows)
- [Configuración Completa](https://docs.openclaw.ai/gateway/configuration)

## Licencia

Este proyecto de documentación es de uso interno. OpenClaw está bajo licencia MIT.
