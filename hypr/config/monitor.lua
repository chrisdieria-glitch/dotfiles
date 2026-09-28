-- Physical layout: eDP-1 (laptop) on the left, HDMI-A-1 on the right.
-- Positions are LOGICAL px, so they must be derived from the scaled size.
-- eDP-1 is 1920x1200; Hyprland snaps the requested 1.07 to 1.0666667
-- (1920/1800) to keep integer logical sizes -> 1800x1125 logical.
-- Recompute these if eDP-1's resolution or scale ever changes.
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = 1.07,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "1800x0",
	scale = 1.25,
})

hl.monitor({
	output = "DP-2",
	mode = "preferred",
	position = "auto",
	scale = 1.0,
})

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
