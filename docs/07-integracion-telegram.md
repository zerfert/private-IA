# 07 - Integración con Telegram

## Crear un Bot en Telegram

### Paso 1: Crear el Bot con BotFather
1. Abrir Telegram
2. Buscar **@BotFather**
3. Enviar `/newbot`
4. Seguir las instrucciones:
   - Nombre del bot: `Mi OpenClaw Assistant`
   - Username del bot: `mi_openclaw_bot` (debe terminar en `_bot`)
5. **Copiar el Bot Token** que BotFather proporciona

### Paso 2: Configurar Permisos del Bot
Con @BotFather:
```
/setprivacy → Disable (para que pueda leer mensajes en grupos)
/setjoingroups → Enable (para que pueda unirse a grupos)
```

## Configurar en OpenClaw

### Opción 1: Variable de entorno
```bash
export TELEGRAM_BOT_TOKEN="123456789:ABCdefGHIjklMNOpqrsTUVwxyz"
echo 'export TELEGRAM_BOT_TOKEN="123456789:ABCdefGHIjklMNOpqrsTUVwxyz"' >> ~/.bashrc
```

### Opción 2: En el archivo de configuración
Editar `~/.openclaw/openclaw.json`:

```json
{
  "agent": {
    "model": "anthropic/claude-opus-4-6"
  },
  "channels": {
    "telegram": {
      "botToken": "123456789:ABCdefGHIjklMNOpqrsTUVwxyz",
      "allowFrom": [
        "tu_username_de_telegram"
      ]
    }
  }
}
```

## Configuración de Seguridad

### Allowlist de Usuarios (Muy Importante)
Solo los usuarios en `allowFrom` podrán hablar con el bot:

```json
{
  "channels": {
    "telegram": {
      "botToken": "TU_TOKEN",
      "allowFrom": [
        "usuario1",
        "usuario2"
      ],
      "dmPolicy": "pairing"
    }
  }
}
```

### Políticas de DM
- `"pairing"` — Los desconocidos reciben un código de vinculación (recomendado)
- `"open"` — Cualquiera puede hablar (⚠️ usar con precaución)

### Configuración de Grupos
```json
{
  "channels": {
    "telegram": {
      "groups": {
        "-1001234567890": {
          "requireMention": true
        }
      }
    }
  }
}
```

## Verificar la Integración

1. Reiniciar el Gateway:
```bash
openclaw gateway restart
```

2. Abrir Telegram y enviar un mensaje al bot
3. Verificar en los logs:
```bash
openclaw gateway logs | grep telegram
```

## Comandos de Chat en Telegram

Enviar estos comandos al bot:
- `/status` — Ver estado de la sesión
- `/new` o `/reset` — Reiniciar sesión
- `/think high` — Activar pensamiento profundo
- `/verbose on` — Respuestas detalladas

## Siguiente Paso
→ [08 - Integración con Discord](08-integracion-discord.md)
