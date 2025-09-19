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
in {
  imports = [
    ./hyprpanel.nix
    ./hyprlock.nix
    ./hypridle.nix
    # ./hyprpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    settings = {
      "$mod" = "SUPER";
      "$browser" = myConfig.browser;
      "$files" = "thunar";
      "$term" = myConfig.terminal;

      "$mon1" = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000A46";
      "$mon2" = "desc:Microstep MSI G24C4 0x00000336";
      monitor = [
        "$mon1,highrr,0x0,1"
        "$mon2,highrr,-1920x0,1"
        "eDP-1,preferred,2560x200,1"
        ", preferred, auto, 1"
      ];
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

          "$mod, V, togglespecialworkspace"
          "$mod, F, fullscreen"

          "$mod, SPACE, exec, rofi -show drun -display-drun \"\""
          "$mod+SHIFT, S, exec, hyprshot -m region --clipboard-only -z"
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
        ", XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
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
              ]
            )
            5)
        );
      windowrule = [
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        "bordersize 2, floating:0, onworkspace:s[1]"
        "rounding 10, floating:0, onworkspace:s[1]"
      ];
      decoration = {
        blur.passes = 2;
      };
      layerrule = [
        "blur, bar-0"
      ];

      input = {
        kb_options = "caps:swapescape";
        kb_layout = "gb";
        accel_profile = "flat";
      };

      device = touchpadDevices;

      "exec-once" = [
      ];
    };
  };
}
