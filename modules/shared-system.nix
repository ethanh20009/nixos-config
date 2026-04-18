{
  pkgs,
  lib,
  config,
  ...
}: let
  myPackages = with pkgs;
    [
      killall
      kitty
      firefox
      playerctl
      pavucontrol
      wl-clipboard
      gh
      discord
      brightnessctl
      postman
      brave
      usbutils
      postgresql
      gthumb
      ripgrep
      wezterm
      zip
      jq
      git-crypt
      tldr
      obsidian
      gpu-screen-recorder-gtk
      fd
      mpv
      nh
      lsof
      moreutils
      spotify
      hyprpicker
      easyeffects
      qpwgraph
      ldacbt
      claude-code
    ]
    ++ lib.optional config.myConfig.extras.deno.enable pkgs.deno;
in {
  imports = [
    ./ollama-cuda.nix
  ];

  options.myConfig = {
    defaultPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Packages to install by default on the system.";
    };
  };

  config = {
    myConfig.defaultPackages = myPackages;
    nix.settings = {
      extra-substituters = ["https://devenv.cachix.org"];
      extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="];
    };

    stylix.image = config.myConfig.wallpaper;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.gpu-screen-recorder.enable = true;

    security.polkit.enable = true;

    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # settings = {
      #   General = {
      #     FastConnectable = true;
      #     Experimental = true;
      #   };
      #   Policy = {
      #     AutoEnable = false;
      #   };
      # };
    };
  };
}
