{lib, ...}: {
  options.myConfig = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "brave --profile-directory=\"Default\" --hide-crash-restore-bubble --restore-last-session";
      description = "System default browser";
    };
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../wallpapers/colorful-planets.jpg;
      description = "Wallpaper";
    };
    hyprland = {
      primaryMonitor = {
        "4k" = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use monitor as 4k";
        };
        rr = lib.mkOption {
          type = lib.types.float;
          default = 60.0;
          description = "Refresh rate to use";
        };
        hdr = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use HDR";
        };
        tenbit = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use 10 bit";
        };
        vrr = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "VRR Mode: 0 - off, 1 - always, 2 - fullscreen, 3 - auto game detection (not always detects)";
        };
      };
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
      autostartApps = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Program name.";
            };
            workspace = lib.mkOption {
              type = lib.types.int;
              description = "Workspace number.";
            };
          };
        });
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

    tex.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Install Tex system wide
      '';
    };
  };
}
