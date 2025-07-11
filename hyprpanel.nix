{inputs, ...}: {
  programs.hyprpanel = {
    enable = true;
    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null

    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      "bar.layouts" = {
        "0" = {
          left = ["dashboard" "workspaces"];
          middle = ["media"];
          right = ["volume" "network" "notifications" "battery" "systray" "clock"];
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
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
