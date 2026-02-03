{
  config,
  pkgs,
  inputs,
  lib,
  myConfig,
  ...
}: let
  touchpadDevices =
    map (device_name: {
      name = device_name;
      accel_profile = "adaptive";
    })
    myConfig.hyprland.touchpadDevices;

  pMonitorHDR =
    if myConfig.hyprland.primaryMonitor.hdr
    then ",cm,hdr"
    else "";

  pMonitorTenBit =
    if myConfig.hyprland.primaryMonitor.tenbit
    then ",bitdepth,10"
    else "";

  pMonitorVrr = ",vrr," + toString myConfig.hyprland.primaryMonitor.vrr;

  monitorConfig =
    if myConfig.hyprland.primaryMonitor."4k"
    then [
      ("$mon1,3840x2160@${toString myConfig.hyprland.primaryMonitor.rr},0x0,1.5" + pMonitorVrr + pMonitorTenBit + pMonitorHDR)
      "$mon2,highrr,2560x200,1"
      "eDP-1,preferred,-1920x0,1"
      "desc:AMZ FireTV,3840x2160@60,auto,1"
      ", preferred, auto, 1"
    ]
    else [
      ("$mon1,2560x1440@${toString myConfig.hyprland.primaryMonitor.rr},0x0,1" + pMonitorVrr + pMonitorTenBit + pMonitorHDR)
      "$mon2,highrr,2560x200,1"
      "eDP-1,preferred,-1920x0,1"
      "desc:AMZ FireTV,3840x2160@60,auto,1"
      ", preferred, auto, 1"
    ];

  autostartApps = map (appConfig: "[workspace ${toString appConfig.workspace} silent] ${appConfig.name}") myConfig.hyprland.autostartApps;
in {
  imports = [
    ./celestia.nix
    ./hyprlock.nix
    ./hypridle.nix
    # ./hyprpaper.nix
  ];

  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      allow_token_by_default = true
    }
  '';
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

    settings = {
      "$mod" = "SUPER";
      "$browser" = myConfig.browser;
      "$files" = "thunar";
      "$term" = myConfig.terminal;

      "$mon1" = "desc:Microstep MAG 274U E16M CF0H105600717";
      "$mon2" = "desc:Microstep MSI G24C4 0x00000336";
      monitor = monitorConfig;
      dwindle = {
        preserve_split = true;
      };
      bind =
        [
          "$mod, RETURN, exec, $term"
          "$mod, Q, killactive"
          "$mod, B, exec, $browser"
          "$mod, E, exec, $files"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "SHIFT+$mod, H, movewindow, l"
          "SHIFT+$mod, L, movewindow, r"
          "SHIFT+$mod, K, movewindow, u"
          "SHIFT+$mod, J, movewindow, d"
          "CTRL+$mod, H, resizeactive, -10 0"
          "CTRL+$mod, L, resizeactive, 10 0"
          "CTRL+$mod, K, resizeactive, 0 -10"
          "CTRL+$mod, J, resizeactive, 0 10"

          "$mod SHIFT, P, swapsplit"
          "$mod CTRL, P, togglesplit"
          "$mod SHIFT, G, togglegroup"

          "$mod, V, togglespecialworkspace"
          "$mod, F, fullscreen"

          "$mod, SPACE, exec, caelestia shell drawers toggle launcher"
          "$mod, N, exec, caelestia shell drawers toggle sidebar"
          "$mod+SHIFT, S, exec, hyprshot -m region --clipboard-only -z"
          "$mod+CTRL, S, exec, hyprshot -m region -z"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        )
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                fkey = i + 1;
                ws = i + 11;
              in [
                "$mod, F${toString fkey}, workspace, ${toString ws}"
                "$mod SHIFT, F${toString fkey}, movetoworkspace, ${toString ws}"
              ]
            )
            4)
        );
      bindr = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%- "
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl pause"
        # ", code:172, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general."col.inactive_border" = lib.mkForce "0xff444444";

      bezier = [
        "easeInOut, 0.65, 0, 0.35, 1"
      ];
      animation = [
        "workspaces, 1, 2, default"
        "windows, 1, 2, default, popin"
        "fade, 1, 2, easeInOut"
        "specialWorkspaceIn, 1, 2, default, slidefadevert -100%"
        "specialWorkspaceOut, 1, 2, default, slidefadevert -100%"
      ];

      misc = {
        focus_on_activate = true;
      };

      workspace =
        [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"

          "s[1], gapsout:50, gapsin:50"
        ]
        ++ (
          # binds workspaces 1-5, 6-10 to DP-1, DP-2
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "${toString ws}, monitor:$mon1"
                "${toString (ws + 5)}, monitor:$mon2"
                "${toString (ws + 10)}, monitor:eDP-1"
              ]
            )
            5)
        );
      windowrule = [
        "border_size 0, match:float 0, match:workspace w[tv1]"
        "rounding 0, match:float 0, match:workspace w[tv1]"
        "border_size 0, match:float 0, match:workspace f[1]"
        "rounding 0, match:float 0, match:workspace f[1]"

        "border_size 2, match:float 0, match:workspace s[1]"
        "rounding 10, match:float 0, match:workspace s[1]"

        "match:class steam_app.*, content game"
        "match:class steam_app.*, immediate yes"
      ];
      general = {
        allow_tearing = true;
      };
      render = {
        direct_scanout = 2;
      };
      cursor = {
        no_hardware_cursors = false;
        use_cpu_buffer = true;
        min_refresh_rate = 50;
      };
      decoration = {
        rounding = 10;
      };
      xwayland = {
        "force_zero_scaling" = true;
      };

      input = {
        kb_options = "caps:swapescape";
        kb_layout = "gb";
        accel_profile = "flat";
        # sensitivity = "-0.3";
      };

      device = touchpadDevices;

      "exec-once" = autostartApps;
    };
  };
}
