# 01 - Requisitos Previos del Sistema

## ⚡ Dos Rutas de Instalación

| | Ruta A: Windows Nativo | Ruta B: WSL2 |
|---|---|---|
| **Dificultad** | ⭐ Fácil | ⭐⭐ Media |
| **Virtualización** | ❌ No necesaria | ✅ Necesaria |
| **WSL2** | ❌ No necesario | ✅ Necesario |
| **Funcionalidad** | Completa para uso básico | Completa + avanzado |
| **Ideal para** | Mayoría de usuarios | Usuarios avanzados |

> **💡 Recomendación:** Si solo necesitas el Gateway + canales de mensajería (Telegram/Discord/WhatsApp) + modelo de IA, **la Ruta A (Windows Nativo) es suficiente** y no requiere virtualización.

## Sistema Operativo
- **Windows 11** (versión 21H2 o superior)
- Windows 10 Build 19041+ (también funciona)

## Hardware Mínimo

### Ruta A (Windows Nativo):
- **RAM:** 4 GB mínimo (8 GB recomendado)
- **Disco:** 5 GB de espacio libre
- **Procesador:** Cualquier CPU moderna
- **Virtualización:** ❌ NO necesaria

### Ruta B (WSL2):
- **RAM:** 8 GB mínimo (16 GB recomendado)
- **Disco:** 20 GB de espacio libre
- **Procesador:** CPU con soporte de virtualización (Intel VT-x o AMD-V)
- **Virtualización:** ✅ Debe estar habilitada en BIOS

## Software Necesario

### Ruta A (Windows Nativo):
1. **Node.js** ≥ 22 (LTS recomendado)
2. **npm** (viene con Node.js)

### Ruta B (WSL2):
1. **WSL2** (Windows Subsystem for Linux 2)
2. **Node.js** ≥ 22 (LTS recomendado)
3. **npm** o **pnpm** (gestor de paquetes)
4. **Git** (control de versiones)

## Cuentas Necesarias

### Para el Modelo de IA (al menos una):
- **Anthropic (Claude):** https://console.anthropic.com/
  - Obtener API Key
  - Modelo recomendado: `anthropic/claude-opus-4-6`
- **OpenAI:** https://platform.openai.com/
  - Obtener API Key
  - Modelo recomendado: `openai/gpt-4o`

### Para Integración de Canales (al menos una):
- **Telegram:**
  - Crear un bot con @BotFather
  - Obtener el Bot Token
- **Discord:**
  - Crear una aplicación en https://discord.com/developers/applications
  - Obtener el Bot Token
- **WhatsApp:**
  - Se configura vinculando dispositivo (no requiere API externa)

## Verificación de Requisitos

### Ruta A (Windows Nativo) - Solo verificar Node.js:
```powershell
node --version    # Debe mostrar v22.x.x
npm --version     # Debe mostrar 10.x.x
```

Si no tienes Node.js:
```powershell
winget install OpenJS.NodeJS.LTS
```

### Ruta B (WSL2) - Verificar virtualización:
```powershell
# Verificar versión de Windows
[System.Environment]::OSVersion.Version

# Verificar si la virtualización está habilitada
Get-ComputerInfo -Property "HyperVRequirementVirtualizationFirmwareEnabled"

# Verificar si WSL ya está instalado
wsl --version
```

## Siguiente Paso

### ⭐ Ruta A (Recomendada - Sin WSL2):
→ [12 - Instalación Nativa en Windows](12-instalacion-nativa-windows.md)

### Ruta B (Con WSL2):
→ [02 - Instalación de WSL2](02-instalacion-wsl2.md)
