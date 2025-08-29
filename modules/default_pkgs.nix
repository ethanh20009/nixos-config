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
    pkgs.btop
    pkgs.discord
    pkgs.brightnessctl
    (flameshot.override {enableWlrSupport = true;})
    pkgs.postman
    pkgs.brave
    pkgs.usbutils
    postgresql
    gthumb
  ];
in {
  # This part declares the option
  options.myConfig.defaultPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    description = "Packages to install by default on the system.";
  };

  # This part sets the value of the option
  config.myConfig.defaultPackages = myPackages;
}
