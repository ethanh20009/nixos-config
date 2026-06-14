local nix = require("nix")
local mod = "SUPER"

-- Applications
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(nix.terminal))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + B", hl.dsp.exec_cmd(nix.browser))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))

-- Focus movement
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Window movement
hl.bind("SHIFT + " .. mod .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SHIFT + " .. mod .. " + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SHIFT + " .. mod .. " + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SHIFT + " .. mod .. " + J", hl.dsp.window.move({ direction = "d" }))

-- Window resizing
hl.bind("CTRL + " .. mod .. " + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind("CTRL + " .. mod .. " + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind("CTRL + " .. mod .. " + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind("CTRL + " .. mod .. " + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }))

-- Layout actions
hl.bind("SHIFT + " .. mod .. " + P", hl.dsp.layout("swapsplit"))
hl.bind("CTRL + " .. mod .. " + P", hl.dsp.layout("togglesplit"))
hl.bind("SHIFT + " .. mod .. " + G", hl.dsp.layout("togglegroup"))

-- Window state
hl.bind(mod .. " + V", hl.dsp.workspace.toggle_special())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Caelestia and screenshot utilities
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("caelestia shell drawers toggle launcher"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("caelestia shell drawers toggle sidebar"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only -z"))
hl.bind(mod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m region -z"))
hl.bind(mod .. " + ALT + S", hl.dsp.exec_cmd("hyprshot -m window -z"))
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd("hyprpicker | wl-copy"))

-- Workspace switching & moving windows to workspaces (1-9)
for i = 0, 8 do
  local ws = i + 1
  hl.bind(mod .. " + code:1" .. tostring(i), hl.dsp.focus({ workspace = ws }))
  hl.bind("SHIFT + " .. mod .. " + code:1" .. tostring(i), hl.dsp.window.move({ workspace = ws }))
end

-- Workspace switching & moving windows to workspaces (11-14 / F1-F4)
for i = 0, 3 do
  local fkey = i + 1
  local ws = i + 11
  hl.bind(mod .. " + F" .. tostring(fkey), hl.dsp.focus({ workspace = ws }))
  hl.bind("SHIFT + " .. mod .. " + F" .. tostring(fkey), hl.dsp.window.move({ workspace = ws }))
end

-- Media & volume keys (release binds)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { release = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { release = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { release = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { release = true })

-- Media keys (locked binds)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Mouse actions
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
