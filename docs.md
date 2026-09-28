# Reportes de Proyecto

Historial de cambios y problemas encontrados.

---

## 2026-07-09

### Cambios realizados
- Migración de `hyprland.conf` (formato heredado) a `hyprland.lua` (nuevo formato Lua, Hyprland 0.55+)
- Archivos creados:
  - `hypr/hyprland.lua` — Entry point principal, requiere los 5 módulos
  - `hypr/config/env.lua` — Variables de entorno (XCURSOR, XDG, MOZ, QT, etc.)
  - `hypr/config/monitor.lua` — Monitores (HDMI-A-1, eDP-1, DP-3) + asignación de workspaces
  - `hypr/config/settings.lua` — Configuración general (cursor, gaps, borders, decoration, blur, input) + curvas y animaciones
  - `hypr/config/binds.lua` — Todos los keybinds, incluyendo binds de medios, mouse, lid switch
  - `hypr/config/startup.lua` — Autostart con `hl.on("hyprland.start", ...)`
- Animaciones añadidas: 6 curvas (bezier + spring) y 17 leaves de animación
- Fix: `preffered` → `preferred` en monitor HDMI-A-1

### Problemas encontrados
- Ninguno

### Estado
- Configuración de Hyprland migrada a Lua exitosamente
- `hyprland.conf` antiguo se conserva como respaldo
- `hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf`, `scripts/` sin cambios

---

## 2026-07-09 (segunda iteración)

### Cambios realizados
- Creado `install.sh` — Instalador automatizado completo que reemplaza al antiguo `.install.sh`
- Creado `zsh/.zshrc` — Configuración de Zsh con Oh My Zsh + Powerlevel10k + zoxide + plugins
- Creado `zsh/p10k.zsh` — Configuración de Powerlevel10k (estilo lean, nerdfont)
- Eliminado `.install.sh` (obsoleto, reemplazado por `install.sh`)

### Detalles del instalador (`install.sh`)
- **check_system()**: Verifica que sea Arch Linux y que no se ejecute como root
- **install_yay()**: Construye e instala yay desde AUR si no está presente
- **install_packages()**: Instala todos los paquetes oficiales detectados de los configs
- **install_aur_packages()**: Instala hyprshot, sway-notification-center, bibata-cursor-theme via yay
- **install_zsh() / install_ohmyzsh() / install_powerlevel10k()**: Configura el entorno Zsh
- **backup_existing_configs()**: Respaldos en `~/.dotfiles_backup/` con timestamp
- **create_symlinks()**: Crea symlinks para hypr, kitty, waybar, wofi, nvim, .zshrc, .p10k.zsh
- **set_default_shell()**: Cambia el shell por defecto a zsh

### Paquetes instalados
- **Oficiales**: hyprland, hypridle, hyprlock, hyprpaper, waybar, kitty, wofi, neovim, dolphin, firefox, zsh, zoxide, pipewire, pipewire-pulse, wireplumber, pavucontrol, brightnessctl, bluez, bluez-utils, libnotify, wl-clipboard, qt6ct, ttf-jetbrains-mono-nerd, git
- **AUR**: hyprshot, sway-notification-center, bibata-cursor-theme

### Problemas encontrados
- `.zshrc` y `.p10k.zsh` no existían en el repositorio (los symlinks en ~/ estaban rotos). Se crearon con valores por defecto sensatos.

### Estado
- Instalador funcional, idempotente y específico para este repositorio
- `zsh/` agregado a la estructura del repositorio
- Para usar: `chmod +x install.sh && ./install.sh`

---

## 2026-07-09 (tercera iteración)

### Cambios realizados
- **`zsh/.zshrc`**: Actualizado con nuevos plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf), integración de fzf (`source <(fzf --zsh)`), y aliases (ls→eza, ll→eza -l, cat→bat)
- **`.install.sh`**:
  - `install_packages()`: Agregados `fzf`, `bat`, `eza`
  - `install_ohmyzsh()`: Agregado `RUNZSH=no CHSH=no` para evitar cambio de shell durante la instalación de Oh My Zsh
  - Nueva función `install_zsh_plugins()`: Clona zsh-autosuggestions y zsh-syntax-highlighting en custom/plugins/
  - `main()`: Agregada llamada a `install_zsh_plugins` en Step 4

### Paquetes agregados
- `fzf`, `bat`, `eza` (oficiales)

### Estado
- Script verificado sintácticamente (bash -n)
- Configuración de Zsh completa con plugins, aliases e integración de herramientas modernas

---

## 2026-09-26

### Cambios realizados
- Corregida la posición de los monitores para respetar la disposición física real: **eDP-1 a la izquierda, HDMI-A-1 a la derecha**
- `hypr/config/monitor.lua` (config activa):
  - `eDP-1`: `position` `4608x0` → `0x0` (pasa a ser el ancla izquierda)
  - `HDMI-A-1`: `position` `2560x0` → `1800x0` (queda pegado al eDP-1)
  - Bloques reordenados para que eDP-1 se lea primero
  - Comentario añadido documentando de dónde sale el `1800`
- `hypr/hyprland.conf` (respaldo, sincronizado): mismas posiciones + fix del typo `preffered` → `preferred` en HDMI-A-1

### Problemas encontrados
- **Las posiciones estaban calculadas con anchos físicos, no lógicos.** Hyprland posiciona en píxeles *lógicos* (ya divididos por la escala), pero los valores `2560x0` y `4608x0` corresponden a los anchos físicos. Esto dejaba un **hueco de ~2560px lógicos** entre ambos monitores (HDMI-A-1 terminaba en x=2048 con scale 1.25, pero eDP-1 arrancaba en x=4608).
- **`hypr/hyprland.conf` es config muerta.** El journal confirma que Hyprland carga `hyprland.lua`:
  `[cfg] Using lua config found at /home/chris/.config/hypr/hyprland.lua`
  Las ediciones a `monitor.lua` son las que surten efecto; las de `hyprland.conf` solo valen como respaldo.
- **`hyprctl keyword monitor` no funciona** bajo el parser no-legacy de Lua:
  `keyword can't work with non-legacy parsers. Use eval.`
  Se aplicó en caliente con `hyprctl eval 'hl.monitor({...})'` en lugar de `hyprctl reload`, para no re-lanzar los procesos de `startup.lua` (waybar, hyprpaper, hypridle, swaync, cliphist). Nota: `hyprctl reload config-only` tampoco habría servido, ya que omite la recarga de monitores.

### Detalles de escala
- eDP-1 es 1920x1200; Hyprland ajusta el `1.07` pedido a **1.0666667** (1920/1800) para mantener tamaños lógicos enteros → **1800x1125 lógico**
- HDMI-A-1 es 2560x1440 @ 1.25 → **2048x1152 lógico**
- El `1800x0` de HDMI-A-1 depende de la escala de eDP-1: si se cambia esa escala o resolución, hay que recalcular

### Verificación
- `hyprctl monitors` → `eDP-1 ... at 0x0`, `HDMI-A-1 ... at 1800x0`, hueco cerrado
- `hyprctl configerrors` → vacío

### Estado
- Distribución de monitores corregida y aplicada en caliente, sin necesidad de reiniciar sesión
- Ambos archivos de config sincronizados
- Sin cambios en `settings.lua`, `binds.lua`, `env.lua`, `startup.lua`, `hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf`
