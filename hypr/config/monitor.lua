hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "2560x0",
    scale    = 1.25,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "4608x0",
    scale    = 1.25,
})

hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "auto",
    scale    = 1.00,
})

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
