# 04 - Instalación de OpenClaw

## Instalación Global (Recomendado)

### Opción 1: Con npm
```bash
npm install -g openclaw@latest
```

### Opción 2: Con pnpm
```bash
pnpm add -g openclaw@latest
```

## Verificar la Instalación

```bash
openclaw --version
```

## Onboarding (Configuración Guiada)

OpenClaw incluye un asistente de configuración que guía paso a paso:

```bash
openclaw onboard --install-daemon
```

El asistente te guiará a través de:
1. **Configuración del Gateway** (plano de control)
2. **Selección del modelo de IA** (Claude, OpenAI, etc.)
3. **Autenticación** con el proveedor de IA
4. **Configuración del workspace**
5. **Instalación del daemon** (servicio en segundo plano)

## Instalación desde el Código Fuente (Avanzado)

Si prefieres compilar desde el código fuente:

```bash
# Clonar el repositorio
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# Instalar dependencias
pnpm install

# Compilar la UI
pnpm ui:build

# Compilar el proyecto
pnpm build

# Ejecutar el onboarding
pnpm openclaw onboard --install-daemon
```

## Estructura de Archivos de OpenClaw

Después de la instalación, OpenClaw crea la siguiente estructura:

```
~/.openclaw/
├── openclaw.json          # Configuración principal
├── credentials/           # Credenciales de canales
├── workspace/             # Workspace del agente
│   ├── AGENTS.md          # Prompt del agente
│   ├── SOUL.md            # Personalidad del agente
│   ├── TOOLS.md           # Herramientas disponibles
│   └── skills/            # Skills instalados
└── logs/                  # Logs del gateway
```

## Diagnóstico

Ejecutar el doctor para verificar que todo esté bien:

```bash
openclaw doctor
```

## Siguiente Paso
→ [05 - Configuración del Gateway](05-configuracion-gateway.md)
