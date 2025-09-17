{
  pkgs,
  lib,
  ...
}: let
  myPackages = with pkgs; [
    killall
    pkgs.kitty
    pkgs.firefox
    pkgs.playerctl
    pkgs.pavucontrol
    pkgs.wl-clipboard
    pkgs.gh
    pkgs.discord
    pkgs.brightnessctl
    pkgs.postman
    pkgs.brave
    pkgs.usbutils
    postgresql
    gthumb
    ripgrep
    wezterm
    zip
    jq
  ];
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

    security.polkit.enable = true;

    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
