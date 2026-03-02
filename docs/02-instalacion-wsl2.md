# 02 - Instalación de WSL2

## ¿Por qué WSL2?

OpenClaw funciona mejor en entornos Linux. WSL2 proporciona un kernel completo de Linux dentro de Windows, lo que permite ejecutar OpenClaw de forma nativa sin necesidad de una máquina virtual separada.

## Instalación Automática

### Opción 1: Script automatizado (recomendado)

Abrir **PowerShell como Administrador** y ejecutar:

```powershell
.\scripts\install-wsl2.ps1
```

### Opción 2: Instalación manual

1. **Habilitar WSL:**
```powershell
wsl --install
```

2. **Configurar WSL2 como versión por defecto:**
```powershell
wsl --set-default-version 2
```

3. **Instalar Ubuntu 22.04:**
```powershell
wsl --install -d Ubuntu-22.04
```

4. **Reiniciar Windows** después de la instalación.

## Configuración Inicial de Ubuntu

Después del reinicio, abrir Ubuntu desde el menú de inicio:

1. **Crear usuario y contraseña** (se pedirá en el primer inicio)

2. **Actualizar el sistema:**
```bash
sudo apt update && sudo apt upgrade -y
```

3. **Instalar herramientas básicas:**
```bash
sudo apt install -y curl wget git build-essential
```

## Verificar la Instalación

```bash
# Desde PowerShell
wsl --list --verbose

# Debería mostrar:
#   NAME            STATE           VERSION
# * Ubuntu-22.04    Running         2
```

```bash
# Desde la terminal de Ubuntu
cat /etc/os-release
uname -r
```

## Configuración de Memoria WSL2 (Opcional)

Crear archivo `%USERPROFILE%\.wslconfig`:

```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
```

## Solución de Problemas Comunes

### Error: "La virtualización no está habilitada"
1. Reiniciar PC y entrar al BIOS/UEFI
2. Habilitar Intel VT-x o AMD-V
3. Guardar y reiniciar

### Error: "WSL2 requiere una actualización del kernel"
```powershell
wsl --update
```

## Siguiente Paso
→ [03 - Instalación de Node.js](03-instalacion-nodejs.md)
