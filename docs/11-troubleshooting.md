# 11 - Troubleshooting (Resolución de Problemas)

## Herramienta de Diagnóstico

Siempre empezar con:
```bash
openclaw doctor
```

Esto verifica:
- Versión de Node.js
- Configuración del gateway
- Estado de canales
- Conectividad con proveedores de IA
- Políticas de seguridad DM

## Problemas Comunes

### 1. El Gateway no inicia

**Síntoma:** `openclaw gateway start` falla o no responde.

**Soluciones:**
```bash
# Verificar si hay otro proceso usando el puerto
lsof -i :18789

# Matar proceso zombie
kill -9 $(lsof -t -i :18789)

# Reiniciar
openclaw gateway start
```

### 2. Error de conexión con el modelo de IA

**Síntoma:** `Error: Authentication failed` o `401 Unauthorized`

**Soluciones:**
```bash
# Verificar que la API key está configurada
echo $ANTHROPIC_API_KEY
echo $OPENAI_API_KEY

# Re-configurar autenticación
openclaw auth login --provider anthropic
```

### 3. Telegram no responde

**Síntoma:** El bot está online pero no responde mensajes.

**Soluciones:**
```bash
# Verificar logs
openclaw gateway logs | grep telegram

# Verificar que el token es correcto
openclaw doctor

# Verificar allowFrom
cat ~/.openclaw/openclaw.json | grep -A5 telegram
```

### 4. WhatsApp se desconecta

**Síntoma:** Mensajes no llegan o error `Connection closed`.

**Soluciones:**
```bash
# Re-vincular dispositivo
rm -rf ~/.openclaw/credentials/whatsapp
openclaw channels login

# Verificar estado
openclaw gateway logs | grep whatsapp
```

### 5. Discord no se conecta

**Síntoma:** Bot aparece offline en Discord.

**Soluciones:**
```bash
# Verificar intents habilitados en Discord Developer Portal
# Verificar token
openclaw gateway logs | grep discord

# Reiniciar gateway
openclaw gateway restart
```

### 6. WSL2 no tiene internet

**Síntoma:** `curl` o `npm` fallan con error de red.

**Soluciones:**
```bash
# Dentro de WSL2
cat /etc/resolv.conf

# Si el DNS está mal, corregir:
sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

# Desde PowerShell (reiniciar WSL)
wsl --shutdown
wsl
```

### 7. Node.js versión incorrecta

**Síntoma:** `Error: Node.js >= 22 required`

**Soluciones:**
```bash
node --version

# Si es menor a 22:
nvm install 22
nvm use 22
nvm alias default 22
```

### 8. Uso excesivo de memoria

**Síntoma:** WSL2 consume mucha RAM.

**Soluciones:**
Crear/editar `%USERPROFILE%\.wslconfig`:
```ini
[wsl2]
memory=4GB
swap=2GB
```
Luego reiniciar WSL:
```powershell
wsl --shutdown
```

## Logs y Debugging

### Ver logs en tiempo real
```bash
openclaw gateway --verbose
```

### Exportar logs para soporte
```bash
openclaw gateway logs > ~/openclaw-debug-$(date +%Y%m%d).log
```

## Contacto para Soporte

Si el problema persiste después de intentar estas soluciones:
1. Ejecutar `openclaw doctor` y guardar la salida
2. Exportar los logs recientes
3. Contactar por Upwork para soporte remoto

## Recursos Adicionales

- [FAQ Oficial](https://docs.openclaw.ai/help/faq)
- [Troubleshooting Oficial](https://docs.openclaw.ai/channels/troubleshooting)
- [Discord de la Comunidad](https://discord.gg/clawd)
- [GitHub Issues](https://github.com/openclaw/openclaw/issues)
