{
  config,
  pkgs,
  inputs,
  lib,
  myConfig,
  ...
}: {
  imports = [
    ./celestia.nix
    # ./hyprlock.nix
    # ./hypridle.nix
    # ./hyprpaper.nix
  ];

  config = lib.mkIf myConfig.hyprland.enable {
    home.file.".local/share/hypr/stubs".source = "${pkgs.hyprland}/share/hypr/stubs";

    xdg.configFile = {
      "hypr/hyprland.lua".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-config/modules/hyprland/lua/hyprland.lua";

      "hypr/xdph.conf".text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';

      "hypr/nix.lua".text = ''
        return {
          monitors = {
            primary = {
              resolution = "${
                if myConfig.hyprland.primaryMonitor."4k"
                then "3840x2160"
                else "2560x1440"
              }",
              rr = ${toString myConfig.hyprland.primaryMonitor.rr},
              scale = ${
                if myConfig.hyprland.primaryMonitor."4k"
                then "1.5"
                else "1"
              },
              vrr = ${toString myConfig.hyprland.primaryMonitor.vrr},
              tenbit = ${
                if myConfig.hyprland.primaryMonitor.tenbit
                then "true"
                else "false"
              },
              hdr = ${
                if myConfig.hyprland.primaryMonitor.hdr
                then "true"
                else "false"
              },
            }
          },
          touchpadDevices = {
            ${lib.concatMapStringsSep ",\n            " (dev: ''"${dev}"'') myConfig.hyprland.touchpadDevices}
          },
          autostartApps = {
            ${lib.concatMapStringsSep ",\n            " (app: let
              workspaceString = if app.special then "special" else toString app.workspace;
            in ''"[[[workspace ${workspaceString} silent] ${app.name}]]"'') myConfig.hyprland.autostartApps}
          },
          browser = [[${myConfig.browser}]],
          terminal = [[${myConfig.terminal}]],
          wallpaper = [[${myConfig.wallpaper}]],
        }
      '';
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = ["${myConfig.wallpaper}"];
        wallpaper = [
          {
            monitor = "";
            path = "${myConfig.wallpaper}";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      configType = "lua";
    };
  };
}
