# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cacert = builtins.readFile ../../secrets/ca.cert;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # For NVF
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5b878c3f-b319-4854-9886-7094e13b5a45".device = "/dev/disk/by-uuid/5b878c3f-b319-4854-9886-7094e13b5a45";
  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      WIFI_PWR_ON_BAT = "off";
      WIFI_PWR_ON_AC = "off";

      USB_AUTOSUSPEND = 0;

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;
    };
  };

  services.logind = {
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitch = "suspend";
  };

  home-manager = {
    users."ethan" = {pkgs, ...}: {
      xdg.desktopEntries.slack = {
        name = "Slack";
        exec = "slack --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
        icon = "slack";
        terminal = false;
        categories = ["Network" "InstantMessaging"];
        mimeType = ["x-scheme-handler/slack"];
      };
    };
  };

  environment.systemPackages =
    (with pkgs; [
      slack
      google-cloud-sdk
      networkmanagerapplet
      getopt
      google-chrome
      rocmPackages.rocm-smi
      fx
      claude-code
      socat
      bubblewrap
    ])
    ++ [
      inputs.audselect_rs.packages.${pkgs.system}.default
    ];

  services.earlyoom = {
    enable = true;
    freeSwapThreshold = 5;
    freeSwapKillThreshold = 5;
    freeMemThreshold = 4;
    freeMemKillThreshold = 4;
    extraArgs = [
      "-g"
      "--avoid=^(X|plasma.*|konsole|kwin|.?[Hh]ypr.*)$"
      "--prefer=^(java)$"
    ];
  };

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  programs.fish = {
    shellInit = ''
      umask 0002
      set -gx CHROME_BIN "${pkgs.google-chrome}/bin/google-chrome-stable"
    '';
  };

  networking.extraHosts = ''
    127.0.0.1 collect.flexys.dev collaborate.flexys.dev keycloak.flexys.dev engine.flexys.dev schema-registry brand1.flexys.dev brand2.flexys.dev branda.flexys.dev brandb.flexys.dev broker keycloak
  '';
  security.pki.certificates = [
    cacert
  ];

  myConfig = {
    wallpaper = ../../wallpapers/flexys-dark.jpg;
    hyprland = {
      primaryMonitor = {
        "4k" = true;
        rr = 160.0;
      };
      secondMonitor = true;
      touchpadDevices = ["syna801a:00-06cb:cec6-touchpad"];
      autostartApps = [
        {
          name = "slack";
          workspace = 6;
        }
        {
          name = "$term";
          workspace = 1;
        }
        {
          name = "$browser";
          workspace = 2;
        }
        {
          name = "spotify";
          special = true;
        }
      ];
    };
    extras.deno.enable = true;
    work = true;
    nvf = {
      companion = "claude";
    };
  };
}
