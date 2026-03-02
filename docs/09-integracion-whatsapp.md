# 09 - Integración con WhatsApp

## ⚠️ Nota Importante

La integración de WhatsApp usa **Baileys** (una implementación open-source del protocolo de WhatsApp Web). Esto significa que:
- Se usa tu número personal de WhatsApp
- Se vincula como un dispositivo adicional (similar a WhatsApp Web)
- No requiere API de negocios de Meta

## Configurar WhatsApp en OpenClaw

### Paso 1: Configurar en openclaw.json

```json
{
  "agent": {
    "model": "anthropic/claude-opus-4-6"
  },
  "channels": {
    "whatsapp": {
      "allowFrom": [
        "+1234567890"
      ]
    }
  }
}
```

### Paso 2: Vincular Dispositivo

```bash
# Iniciar el proceso de vinculación
openclaw channels login
```

Esto mostrará un **código QR** en la terminal. Escanéalo con WhatsApp:

1. Abrir **WhatsApp** en tu teléfono
2. Ir a **Configuración** → **Dispositivos vinculados**
3. Tocar **"Vincular un dispositivo"**
4. Escanear el código QR mostrado en la terminal

### Paso 3: Verificar Vinculación

```bash
openclaw gateway restart
openclaw gateway logs | grep whatsapp
```

## Configuración de Seguridad

### Allowlist (MUY IMPORTANTE)

⚠️ **SIEMPRE configura `allowFrom`** para evitar que desconocidos controlen tu asistente:

```json
{
  "channels": {
    "whatsapp": {
      "allowFrom": [
        "+1234567890",
        "+0987654321"
      ],
      "dmPolicy": "pairing"
    }
  }
}
```

### Configuración de Grupos

```json
{
  "channels": {
    "whatsapp": {
      "allowFrom": ["+1234567890"],
      "groups": {
        "*": {
          "requireMention": true
        }
      }
    }
  }
}
```

## Enviar un Mensaje de Prueba

```bash
openclaw message send --to "+1234567890" --message "¡Hola desde OpenClaw!"
```

## Solución de Problemas

### El QR no aparece
```bash
# Limpiar credenciales y reintentar
rm -rf ~/.openclaw/credentials/whatsapp
openclaw channels login
```

### Desconexión frecuente
- WhatsApp puede desconectar el dispositivo vinculado si no se usa en varios días
- Solución: Mantener el Gateway corriendo constantemente

### "Conflicto de dispositivos"
- Solo puedes tener 4 dispositivos vinculados en WhatsApp
- Ir a WhatsApp → Dispositivos vinculados → Eliminar alguno

## Siguiente Paso
→ [10 - Uso Básico](10-uso-basico.md)
