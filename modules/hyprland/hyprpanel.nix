{
  inputs,
  config,
  myConfig,
  ...
}: let
  barLayouts =
    if myConfig.hyprland.secondMonitor
    then {
      "0" = {
        left = ["dashboard" "workspaces"];
        middle = ["media"];
        right = ["volume" "network" "notifications" "hypridle" "systray" "clock"];
      };
      "1" = {
        left = ["dashboard" "workspaces"];
        middle = ["media"];
        right = ["volume" "network" "notifications" "hypridle" "systray" "clock"];
      };
    }
    else {
      "0" = {
        left = ["dashboard" "workspaces"];
        middle = ["media"];
        right = ["volume" "network" "notifications" "hypridle" "battery" "systray" "clock"];
      };
    };
in {
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null

    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      "bar.layouts" = barLayouts;
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.workspaces.ignored = "-99";
      bar.battery.label = true;

      menus.clock = {
        time = {
          military = false;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      # menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };
}
