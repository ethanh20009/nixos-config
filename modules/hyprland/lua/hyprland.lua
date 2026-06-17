local HOME = os.getenv("HOME")
local PUBLIC = HOME .. "/nixos-config/modules/hyprland/lua"
local XDG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

package.path = package.path .. ";" .. PUBLIC .. "/?.lua" .. ";" .. XDG .. "/hypr" .. "/?.lua"

require("appearance")
require("input")
require("rules")
require("keybinds")
require("autostart")
