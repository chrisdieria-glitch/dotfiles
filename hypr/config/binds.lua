local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "wofi --show drun"
local browser     = "firefox"
local codeEditor  = "code"
local scripts     = "~/.config/hypr/scripts"

-- Launchers
hl.bind(mainMod .. "+Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. "+B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+V", hl.dsp.exec_cmd(codeEditor))
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(menu))

-- Window management
hl.bind(mainMod .. "+C", hl.dsp.window.close())
hl.bind(mainMod .. "+M", hl.dsp.exit())
hl.bind(mainMod .. "+F", hl.dsp.window.fullscreen())

-- Lock & system
hl.bind(mainMod .. "+L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. "+P", hl.dsp.exec_cmd(scripts .. "/power.sh"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(scripts .. "/quick-settings.sh"))
hl.bind(mainMod .. "+W", hl.dsp.exec_cmd(scripts .. "/wifi-menu.sh"))
hl.bind(mainMod .. "+SHIFT+W", hl.dsp.exec_cmd(scripts .. "/bt-menu.sh"))
hl.bind(mainMod .. "+SHIFT+B", hl.dsp.exec_cmd(scripts .. "/brightness-menu.sh"))
hl.bind(mainMod .. "+N", hl.dsp.exec_cmd("swaync-client -t"))

-- Resize windows
hl.bind(mainMod .. "+CTRL+right", hl.dsp.window.resize({ x = 20, y = 0 , relative = true}),  { repeating = true })
hl.bind(mainMod .. "+CTRL+left",  hl.dsp.window.resize({ x = -20, y = 0, relative = true }) , {repeating = true})
hl.bind(mainMod .. "+CTRL+up",    hl.dsp.window.resize({ x = 0, y = -20 , relative = true }), { repeating = true })
hl.bind(mainMod .. "+CTRL+down",  hl.dsp.window.resize({ x = 0, y = 20 , relative = true }),  { repeating = true })

-- Focus movement
hl.bind(mainMod .. "+left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. "+up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "+down",  hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mainMod .. "+SHIFT+left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+SHIFT+right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. "+SHIFT+up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+SHIFT+down",  hl.dsp.window.move({ direction = "down" }))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Workspace switching
for i = 1, 5 do
    hl.bind(mainMod .. "+" .. i, hl.dsp.focus({ workspace = i }))
end

-- Move to workspace
for i = 1, 5 do
    hl.bind(mainMod .. "+SHIFT+" .. i, hl.dsp.window.move({ workspace = i }))
end

-- Mouse binds
hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind("PRINT",                   hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SUPER+PRINT",             hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SUPER+SHIFT+PRINT",       hl.dsp.exec_cmd("hyprshot -m output"))

-- Lid switch
hl.bind("switch:Lid Switch",       hl.dsp.exec_cmd("hyprctl keyword monitor eDP-1,disable"),           { locked = true })
hl.bind("switch:off:Lid Switch",   hl.dsp.exec_cmd("hyprctl keyword monitor eDP-1,preferred,auto,1"),  { locked = true })
