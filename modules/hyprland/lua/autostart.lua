local nix = require("nix")

hl.on("hyprland.start", function ()
  -- Propagate environment variables to systemd user session
  hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP")
  -- Start the systemd session target
  hl.exec_cmd("systemctl --user start hyprland-session.target")

  for _, app in ipairs(nix.autostartApps) do
    -- Replace $term and $browser placeholders with active variables from nix
    local cmd = app:gsub("%$term", nix.terminal):gsub("%$browser", nix.browser)
    hl.exec_cmd(cmd)
  end
end)
