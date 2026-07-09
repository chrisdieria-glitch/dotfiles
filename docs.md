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
