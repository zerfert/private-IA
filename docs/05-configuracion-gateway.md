# 05 - Configuración del Gateway

## ¿Qué es el Gateway?

El Gateway es el **plano de control** de OpenClaw. Gestiona:
- Sesiones y presencia
- Canales de comunicación (WhatsApp, Telegram, Discord, etc.)
- Herramientas del agente
- Eventos y webhooks

## Iniciar el Gateway

### Modo Interactivo (con logs detallados)
```bash
openclaw gateway --port 18789 --verbose
```

### Modo Daemon (en segundo plano)
```bash
openclaw gateway start
```

## Configuración del Gateway

La configuración se encuentra en `~/.openclaw/openclaw.json`:

```json
{
  "gateway": {
    "port": 18789,
    "bind": "loopback",
    "auth": {
      "mode": "none"
    }
  }
}
```

### Opciones de Bind
- `"loopback"` — Solo accesible localmente (por defecto, más seguro)
- `"all"` — Accesible desde cualquier interfaz (solo para redes confiables)

### Opciones de Auth
- `"none"` — Sin autenticación (solo para uso local)
- `"password"` — Requiere contraseña para acceder
- `"token"` — Usa token de autenticación

## Acceder a la UI de Control

Una vez el Gateway está corriendo, acceder a:

```
http://localhost:18789
```

La interfaz web permite:
- Ver el estado de las sesiones
- Monitorear canales conectados
- Ver logs en tiempo real
- Gestionar configuración

## Comandos Útiles del Gateway

```bash
# Estado del gateway
openclaw gateway status

# Reiniciar el gateway
openclaw gateway restart

# Detener el gateway
openclaw gateway stop

# Ver logs
openclaw gateway logs

# Diagnóstico completo
openclaw doctor
```

## Siguiente Paso
→ [06 - Configuración de Modelos IA](06-configuracion-modelos.md)
