# 10 - Guía de Uso Básico

## Comandos CLI Esenciales

### Gestión del Gateway
```bash
openclaw gateway start          # Iniciar en segundo plano
openclaw gateway stop           # Detener
openclaw gateway restart        # Reiniciar
openclaw gateway status         # Ver estado
openclaw gateway --verbose      # Iniciar con logs detallados
```

### Enviar Mensajes
```bash
# Enviar mensaje directo al agente
openclaw agent --message "Hola, ¿cómo estás?"

# Con pensamiento profundo
openclaw agent --message "Analiza este código" --thinking high

# Enviar a un contacto de canal
openclaw message send --to "+1234567890" --message "Hola desde OpenClaw"
```

### Diagnóstico
```bash
openclaw doctor          # Diagnóstico completo
openclaw gateway logs    # Ver logs
```

### Actualización
```bash
openclaw update --channel stable    # Actualizar a la última versión estable
```

## Comandos de Chat (WhatsApp/Telegram/Discord)

Envía estos comandos en cualquier canal conectado:

| Comando | Descripción |
|---------|-------------|
| `/status` | Ver estado de la sesión (modelo, tokens, costo) |
| `/new` o `/reset` | Reiniciar la sesión actual |
| `/compact` | Compactar el contexto (resumir historial) |
| `/think <nivel>` | Nivel de pensamiento: off, minimal, low, medium, high, xhigh |
| `/verbose on/off` | Activar/desactivar respuestas detalladas |
| `/usage off/tokens/full` | Footer de uso por respuesta |
| `/restart` | Reiniciar el gateway (solo owner) |
| `/activation mention/always` | Activación en grupos |

## Personalizar el Agente

### Editar AGENTS.md (Prompt del Sistema)
```bash
nano ~/.openclaw/workspace/AGENTS.md
```

Ejemplo de contenido:
```markdown
# Mi Asistente Personal

Eres un asistente personal inteligente. Responde siempre en español.
Sé conciso y útil. Tu nombre es "Asistente IA".

## Áreas de Experiencia
- Programación y desarrollo de software
- Análisis de datos
- Redacción y comunicación
- Planificación y productividad
```

### Editar SOUL.md (Personalidad)
```bash
nano ~/.openclaw/workspace/SOUL.md
```

## Skills (Habilidades)

### Ver skills instalados
```bash
ls ~/.openclaw/workspace/skills/
```

### El agente puede buscar e instalar skills automáticamente desde ClawHub

## Interfaz Web (Control UI)

Acceder a `http://localhost:18789` para:
- 📊 Dashboard con estado de sesiones
- 💬 WebChat directo con el agente
- ⚙️ Configuración en tiempo real
- 📝 Logs y debugging

## Ejemplo de Flujo de Uso Diario

1. **Iniciar el día:** El gateway se inicia automáticamente (daemon)
2. **Enviar mensajes** por WhatsApp/Telegram/Discord
3. **Consultar estado:** `/status`
4. **Si contexto largo:** `/compact`
5. **Si necesitas precisión:** `/think high`
6. **Reiniciar sesión:** `/new`

## Siguiente Paso
→ [11 - Troubleshooting](11-troubleshooting.md)
