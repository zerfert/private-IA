# 06 - Configuración de Modelos de IA

## Modelos Soportados

OpenClaw soporta múltiples proveedores de IA:

| Proveedor | Modelos Populares | Recomendación |
|-----------|-------------------|---------------|
| **Google** | Gemini 2.5 Flash, Gemini 2.5 Pro | ⭐ Recomendado (rápido y económico) |
| **Anthropic** | Claude Opus 4.6, Claude Sonnet 4.5 | Excelente para contextos largos |
| **OpenAI** | GPT-4o, GPT-5.2, Codex | Bueno para uso general |
| **Otros** | Cualquier modelo compatible con API | Varía |

## Configuración con Google Gemini - Recomendado

### 1. Obtener API Key
1. Ir a https://aistudio.google.com/apikey
2. Iniciar sesión con tu cuenta de Google
3. Clic en "Create API Key"
4. Copiar la clave generada

### 2. Configurar en OpenClaw

Editar `%USERPROFILE%\.openclaw\openclaw.json` (Windows) o `~/.openclaw/openclaw.json` (Linux/WSL2):

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "google/gemini-2.5-flash",
        "fallbacks": ["anthropic/claude-opus-4-6"]
      }
    }
  }
}
```

O por línea de comandos:
```powershell
openclaw config set agents.defaults.model.primary "google/gemini-2.5-flash"
openclaw config set agents.defaults.model.fallbacks '["anthropic/claude-opus-4-6"]'
```

### 3. Configurar la API Key

**Windows (PowerShell):**
```powershell
# Permanente
[System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "AIzaSy-xxxxxxxxxxxxx", "User")
# Reiniciar PowerShell después
```

**Linux/WSL2 (Bash):**
```bash
export GEMINI_API_KEY="AIzaSy-xxxxxxxxxxxxx"
echo 'export GEMINI_API_KEY="AIzaSy-xxxxxxxxxxxxx"' >> ~/.bashrc
source ~/.bashrc
```

## Configuración con Anthropic (Claude)
echo 'export ANTHROPIC_API_KEY="sk-ant-xxxxxxxxxxxxx"' >> ~/.bashrc
source ~/.bashrc
```

## Configuración con OpenAI

### 1. Obtener API Key
1. Ir a https://platform.openai.com/api-keys
2. Crear nueva clave
3. Copiar la clave generada

### 2. Configurar en OpenClaw

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gpt-4o",
        "fallbacks": []
      }
    }
  }
}
```

### 3. Configurar la API Key

**Windows (PowerShell):**
```powershell
[System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-xxxxxxxxxxxxx", "User")
```

**Linux/WSL2 (Bash):**
```bash
export OPENAI_API_KEY="sk-xxxxxxxxxxxxx"
echo 'export OPENAI_API_KEY="sk-xxxxxxxxxxxxx"' >> ~/.bashrc
source ~/.bashrc
```

## Configuración con OAuth (Autenticación Web)

OpenClaw también soporta autenticación OAuth con proveedores:

```bash
openclaw auth login --provider anthropic
# o
openclaw auth login --provider openai
```

Esto abre un navegador para autenticarse.

## Model Failover (Respaldo)

Configurar modelos de respaldo en caso de que el principal falle:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "google/gemini-2.5-flash",
        "fallbacks": [
          "anthropic/claude-opus-4-6",
          "openai/gpt-4o"
        ]
      },
      "models": {
        "google/gemini-2.5-flash": { "alias": "flash" },
        "anthropic/claude-opus-4-6": { "alias": "opus" },
        "openai/gpt-4o": { "alias": "gpt4o" }
      }
    }
  }
}
```

## Verificar Configuración del Modelo

```bash
# Enviar un mensaje de prueba
openclaw agent --message "Hola, ¿estás funcionando correctamente?" --thinking low
```

## Siguiente Paso
→ [07 - Integración con Telegram](07-integracion-telegram.md)
