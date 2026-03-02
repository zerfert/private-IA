# 08 - Integración con Discord

## Crear una Aplicación de Discord

### Paso 1: Crear la Aplicación
1. Ir a https://discord.com/developers/applications
2. Click en **"New Application"**
3. Nombre: `OpenClaw Assistant`
4. Aceptar los términos de servicio

### Paso 2: Crear el Bot
1. En la aplicación creada, ir a **"Bot"** en el menú lateral
2. Click en **"Add Bot"**
3. Configurar:
   - **Username:** `OpenClaw Assistant`
   - **Public Bot:** Desactivar (para que solo tú puedas agregarlo)
4. Click en **"Reset Token"** y **copiar el token**

### Paso 3: Configurar Intents
En la sección **"Bot"** → **"Privileged Gateway Intents"**, habilitar:
- ✅ **Presence Intent**
- ✅ **Server Members Intent**
- ✅ **Message Content Intent**

### Paso 4: Invitar el Bot a tu Servidor
1. Ir a **"OAuth2"** → **"URL Generator"**
2. Seleccionar scopes: `bot`, `applications.commands`
3. Seleccionar permisos:
   - Send Messages
   - Read Message History
   - Embed Links
   - Attach Files
   - Use Slash Commands
4. Copiar la URL generada y abrirla en el navegador
5. Seleccionar tu servidor y autorizar

## Configurar en OpenClaw

### Opción 1: Variable de entorno
```bash
export DISCORD_BOT_TOKEN="TU_DISCORD_BOT_TOKEN"
echo 'export DISCORD_BOT_TOKEN="TU_DISCORD_BOT_TOKEN"' >> ~/.bashrc
```

### Opción 2: En el archivo de configuración
```json
{
  "agent": {
    "model": "anthropic/claude-opus-4-6"
  },
  "channels": {
    "discord": {
      "token": "TU_DISCORD_BOT_TOKEN",
      "allowFrom": [
        "tu_discord_user_id"
      ],
      "dmPolicy": "pairing"
    }
  }
}
```

## Obtener tu Discord User ID

1. En Discord, ir a **Configuración** → **Avanzado** → **Modo Desarrollador** (activar)
2. Click derecho en tu nombre de usuario → **"Copiar ID de usuario"**

## Configuración de Guilds (Servidores)

```json
{
  "channels": {
    "discord": {
      "token": "TU_TOKEN",
      "guilds": {
        "ID_DEL_SERVIDOR": {
          "requireMention": true
        }
      }
    }
  }
}
```

## Verificar la Integración

```bash
# Reiniciar gateway
openclaw gateway restart

# Verificar logs
openclaw gateway logs | grep discord
```

## Siguiente Paso
→ [09 - Integración con WhatsApp](09-integracion-whatsapp.md)
