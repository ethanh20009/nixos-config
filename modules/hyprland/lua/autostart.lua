local nix = require("nix")

hl.on("hyprland.start", function ()
  for _, app in ipairs(nix.autostartApps) do
    -- Replace $term and $browser placeholders with active variables from nix
    local cmd = app:gsub("%$term", nix.terminal):gsub("%$browser", nix.browser)
    hl.exec_cmd(cmd)
  end
end)
