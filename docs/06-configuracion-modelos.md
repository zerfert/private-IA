# 06 - Configuración de Modelos de IA

## Modelos Soportados

OpenClaw soporta múltiples proveedores de IA:

| Proveedor | Modelos Populares | Recomendación |
|-----------|-------------------|---------------|
| **Anthropic** | Claude Opus 4.6, Claude Sonnet 4.5 | ⭐ Recomendado para contextos largos |
| **OpenAI** | GPT-4o, GPT-5.2, Codex | Bueno para uso general |
| **Google** | Gemini Pro, Gemini Ultra | Alternativa competitiva |
| **Otros** | Cualquier modelo compatible con API | Varía |

## Configuración con Anthropic (Claude) - Recomendado

### 1. Obtener API Key
1. Ir a https://console.anthropic.com/
2. Crear cuenta o iniciar sesión
3. Ir a "API Keys" → "Create Key"
4. Copiar la clave generada

### 2. Configurar en OpenClaw

Editar `~/.openclaw/openclaw.json` (Linux/WSL2) o `%USERPROFILE%\.openclaw\openclaw.json` (Windows):

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-6",
        "fallbacks": []
      }
    }
  }
}
```

### 3. Configurar la API Key

**Windows (PowerShell):**
```powershell
# Permanente
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-xxxxxxxxxxxxx", "User")
# Reiniciar PowerShell después
```

**Linux/WSL2 (Bash):**
```bash
export ANTHROPIC_API_KEY="sk-ant-xxxxxxxxxxxxx"
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
        "primary": "anthropic/claude-opus-4-6",
        "fallbacks": [
          "openai/gpt-4o",
          "anthropic/claude-sonnet-4-5"
        ]
      },
      "models": {
        "anthropic/claude-opus-4-6": { "alias": "opus" },
        "openai/gpt-4o": { "alias": "gpt4o" },
        "anthropic/claude-sonnet-4-5": { "alias": "sonnet" }
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
