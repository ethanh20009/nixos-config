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
    ]
    ++ lib.optional config.myConfig.extras.deno.enable pkgs.deno;
in {
  # This part declares the option
  options.myConfig = {
    defaultPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Packages to install by default on the system.";
    };
  };
  # This part sets the value of the option
  config = {
    myConfig.defaultPackages = myPackages;
    nix.settings = {
      extra-substituters = ["https://devenv.cachix.org"];
      extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.gpu-screen-recorder.enable = true;

    security.polkit.enable = true;

    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
