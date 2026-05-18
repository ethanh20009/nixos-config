{lib, ...}: {
  imports = [
    ./hyprland/options.nix
    ./nvf/options.nix
    ./tex/options.nix
  ];

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
