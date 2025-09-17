{lib, ...}: {
  options.myConfig = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "System default browser";
    };
    hyprland = {
      secondMonitor = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable second monitor";
      };
      touchpadDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of touchpad devices from 'hyprctl devices'.
        Will use adaptive accel profile.";
      };
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal application to call";
    };

    work = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Flags if configuration is for work";
    };

    extras = {
      deno.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Deno";
      };
    };

    nvibrant.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to disable dithering";
    };
  };
}
