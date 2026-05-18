# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-0c5be79b-08f2-482c-9329-6ed86912b93f".device = "/dev/disk/by-uuid/0c5be79b-08f2-482c-9329-6ed86912b93f";
  networking.hostName = "nixos"; # Define your hostname.

  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;

  myConfig = {
    tex.enable = true;
  };
}
