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
