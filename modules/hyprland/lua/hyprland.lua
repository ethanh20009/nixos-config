local HOME = os.getenv("HOME")
local XDG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

package.path = package.path
  .. ";" .. XDG .. "/hypr"  .. "/?.lua"

require("appearance")
require("input")
require("rules")
require("keybinds")
require("autostart")
