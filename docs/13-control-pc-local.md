# 13 - Control del PC Local con OpenClaw

## ¿Qué puede hacer OpenClaw en tu PC?

Con la configuración de control local habilitada, OpenClaw puede:

| Capacidad | Herramienta | Descripción |
|-----------|-------------|-------------|
| 🖥️ **Ejecutar comandos** | `exec` | Ejecutar cualquier comando en PowerShell/CMD |
| 📁 **Leer archivos** | `read` | Leer contenido de archivos del sistema |
| ✏️ **Escribir archivos** | `write` | Crear y modificar archivos |
| 📝 **Editar código** | `edit` | Editar archivos existentes con precisión |
| 🔄 **Gestionar procesos** | `process` | Listar, iniciar y detener procesos |
| 🌐 **Navegar la web** | `browser` | Controlar Chrome para buscar, navegar, capturar |
| 🖼️ **Imágenes** | `image` | Generar y procesar imágenes |
| ⏰ **Tareas programadas** | `cron` | Ejecutar tareas automáticas en horarios |
| 🔗 **Sub-agentes** | `subagents` | Delegar tareas a agentes especializados |
| 📡 **Nodos remotos** | `nodes` | Controlar otros dispositivos conectados |

## Configuración Aplicada

### Herramientas habilitadas (tools.sandbox.tools.allow)
```
exec, process, read, write, edit, apply_patch, image, browser, canvas,
sessions_list, sessions_history, sessions_send, sessions_spawn,
subagents, session_status, nodes, cron
```

### Herramientas elevadas
- **Habilitadas**: Permite ejecutar comandos que requieren confirmación

### Node Host
- **Instalado como servicio**: Se ejecuta automáticamente al iniciar Windows
- **Ruta del servicio**: `%USERPROFILE%\.openclaw\node.cmd`
- **Tipo**: Tarea Programada de Windows (schtasks)

## Arquitectura del Control Local

```
┌─────────────────────────────────────────────────┐
│                   Tu PC Windows                  │
│                                                  │
│  ┌───────────┐    ┌──────────────┐              │
│  │  Gateway   │◄──►│  Node Host   │              │
│  │ :18789     │    │  (servicio)  │              │
│  └─────┬─────┘    └──────┬───────┘              │
│        │                  │                      │
│        ▼                  ▼                      │
│  ┌───────────┐    ┌──────────────┐              │
│  │  Browser   │    │   Sistema    │              │
│  │  Control   │    │  (exec/read  │              │
│  │  :18791    │    │   /write)    │              │
│  └───────────┘    └──────────────┘              │
│                                                  │
│  ┌───────────────────────────────┐              │
│  │  Gemini 2.5 Flash (API)      │              │
│  │  El cerebro que decide qué   │              │
│  │  herramientas usar            │              │
│  └───────────────────────────────┘              │
└─────────────────────────────────────────────────┘
```

## Ejemplos de Uso

### Pedirle que ejecute comandos
```
"Abre el Explorador de archivos en Documentos"
"Dime cuánto espacio libre tengo en disco"
"Lista los procesos que más memoria consumen"
"Instala Python 3.12 con winget"
```

### Pedirle que gestione archivos
```
"Crea un respaldo de mi carpeta de proyectos"
"Busca todos los archivos PDF en Descargas"
"Organiza mis descargas por tipo de archivo"
"Lee el contenido de mi archivo config.json"
```

### Pedirle que navegue la web
```
"Busca en Google las últimas noticias de IA"
"Abre YouTube y busca tutoriales de Python"
"Toma una captura de pantalla de esta página web"
"Descarga el PDF de este enlace"
```

### Tareas programadas
```
"Cada día a las 8am, dime el clima"
"Cada lunes, envíame un resumen de mis tareas pendientes"
"Ejecuta un health check cada 6 horas"
```

## Seguridad

### ⚠️ Importante
- OpenClaw pedirá **confirmación** antes de ejecutar comandos potencialmente peligrosos
- La herramienta `elevated` está habilitada pero requiere aprobación por canal
- El gateway solo escucha en **loopback** (127.0.0.1) — no accesible desde la red

### Configurar aprobaciones
```powershell
# Ver política actual de aprobaciones
openclaw approvals get

# Editar lista de comandos permitidos sin aprobación
openclaw approvals allowlist
```

### Restringir herramientas (si lo deseas)
```powershell
# Deshabilitar ejecución de comandos
openclaw config set tools.sandbox.tools.deny '["exec"]'

# Deshabilitar navegador
openclaw config set tools.sandbox.tools.deny '["browser"]'
```

## Verificar que todo funciona

```powershell
# Estado del gateway
openclaw health

# Estado del node host
openclaw node status

# Estado del browser
openclaw browser status

# Política de herramientas
openclaw sandbox explain

# Enviar un mensaje de prueba
openclaw agent --message "¿Puedes decirme la hora actual de mi sistema?" --thinking low
```

## Solución de Problemas

| Problema | Solución |
|----------|----------|
| "exec" no funciona | Verificar que Node Host esté corriendo: `openclaw node status` |
| Browser no conecta | Instalar extensión Chrome de OpenClaw o reiniciar: `openclaw browser start` |
| Comando denegado | Revisar `openclaw sandbox explain` y ajustar `tools.sandbox.tools.allow` |
| Gateway no responde | Reiniciar: `openclaw gateway --port 18789 --verbose` |

## Siguiente Paso
→ Configura tu GEMINI_API_KEY y empieza a dar instrucciones a OpenClaw para que maneje tu PC.
