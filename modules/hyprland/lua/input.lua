local nix = require("nix")

hl.config({
  input = {
    kb_options = "caps:swapescape",
    kb_layout = "gb",
    accel_profile = "flat",
  }
})

for _, deviceName in ipairs(nix.touchpadDevices) do
  hl.device({
    name = deviceName,
    accel_profile = "adaptive",
  })
end
