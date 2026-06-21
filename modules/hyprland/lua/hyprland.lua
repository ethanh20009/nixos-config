local HOME = os.getenv("HOME")
local XDG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

package.path = package.path .. ";" .. XDG .. "/hypr" .. "/?.lua"

require("appearance")
require("input")
require("rules")
require("keybinds")
require("autostart")
