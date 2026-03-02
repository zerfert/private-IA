# 12 - Instalación Nativa en Windows (Sin WSL2)

## ¿Cuándo usar esta ruta?

OpenClaw se puede instalar **directamente en Windows** sin necesidad de WSL2 ni virtualización. Esta es la opción más simple y rápida.

| Característica | Windows Nativo | WSL2 |
|---|---|---|
| Instalación | ⭐ Más simple | Requiere más pasos |
| Virtualización | ❌ No necesaria | ✅ Necesaria |
| Gateway + Canales | ✅ Funciona | ✅ Funciona |
| Telegram / Discord / WhatsApp | ✅ Funciona | ✅ Funciona |
| Herramientas bash avanzadas | ⚠️ Limitadas | ✅ Completas |
| Daemon (servicio en segundo plano) | ⚠️ Con NSSM o Task Scheduler | ✅ systemd nativo |
| Docker / Sandboxing | ⚠️ Docker Desktop | ✅ Nativo |

**Recomendación:** Si solo necesitas Gateway + canales de mensajería + modelo de IA, **la ruta nativa en Windows es suficiente**.

## Paso 1: Instalar Node.js 22 en Windows

### Opción A: Instalador oficial (más fácil)
1. Ir a https://nodejs.org/
2. Descargar **Node.js 22 LTS** (Windows Installer .msi)
3. Ejecutar el instalador con las opciones por defecto
4. Marcar ✅ "Automatically install the necessary tools" si aparece

### Opción B: Con winget (desde PowerShell)
```powershell
winget install OpenJS.NodeJS.LTS
```

### Opción C: Con NVM para Windows
```powershell
# Instalar nvm-windows desde https://github.com/coreybutler/nvm-windows/releases
# Después:
nvm install 22
nvm use 22
```

### Verificar instalación
```powershell
node --version    # Debe mostrar v22.x.x
npm --version     # Debe mostrar 10.x.x
```

## Paso 2: Instalar OpenClaw

Abrir **PowerShell** (no necesita ser Administrador):

```powershell
npm install -g openclaw@latest
```

Verificar:
```powershell
openclaw --version
```

## Paso 3: Ejecutar el Asistente de Configuración

```powershell
openclaw onboard --install-daemon
```

El asistente te guía paso a paso para configurar:
- ✅ Gateway (plano de control)
- ✅ Modelo de IA (Claude / OpenAI)
- ✅ Autenticación con el proveedor
- ✅ Workspace del agente

## Paso 4: Configurar API Key

### Para Anthropic (Claude):
```powershell
# Temporal (solo esta sesión)
$env:ANTHROPIC_API_KEY = "sk-ant-xxxxxxxxxxxxx"

# Permanente (variable de entorno del sistema)
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-xxxxxxxxxxxxx", "User")
```

### Para OpenAI:
```powershell
# Temporal
$env:OPENAI_API_KEY = "sk-xxxxxxxxxxxxx"

# Permanente
[System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-xxxxxxxxxxxxx", "User")
```

> ⚠️ **Después de configurar variables permanentes**, cierra y vuelve a abrir PowerShell.

## Paso 5: Configurar Canal de Mensajería

Editar el archivo de configuración en:
```
%USERPROFILE%\.openclaw\openclaw.json
```

O desde PowerShell:
```powershell
notepad "$env:USERPROFILE\.openclaw\openclaw.json"
```

Ver las guías específicas:
- [Telegram](07-integracion-telegram.md)
- [Discord](08-integracion-discord.md)
- [WhatsApp](09-integracion-whatsapp.md)

## Paso 6: Iniciar el Gateway

```powershell
# Con logs detallados
openclaw gateway --port 18789 --verbose

# En segundo plano
openclaw gateway start
```

Acceder a la UI de control: http://localhost:18789

## Paso 7: Hacer que OpenClaw se ejecute al iniciar Windows

### Opción A: Task Scheduler (Programador de Tareas)
1. Abrir **Programador de tareas** (`taskschd.msc`)
2. Click en **"Crear tarea básica"**
3. Nombre: `OpenClaw Gateway`
4. Desencadenador: **"Al iniciar sesión"**
5. Acción: **"Iniciar un programa"**
   - Programa: `cmd.exe`
   - Argumentos: `/c openclaw gateway start`
6. Marcar ✅ "Abrir diálogo de propiedades al finalizar"
7. En propiedades → marcar **"Ejecutar tanto si el usuario inició sesión como si no"**

### Opción B: Script de inicio automático
Crear un archivo `.bat` en la carpeta de inicio:
```powershell
# Abrir la carpeta de inicio
explorer shell:startup
```

Crear `openclaw-start.bat` con:
```batch
@echo off
openclaw gateway start
```

## Diagnóstico

```powershell
openclaw doctor
```

## Siguiente Paso
→ [10 - Uso Básico](10-uso-basico.md)
