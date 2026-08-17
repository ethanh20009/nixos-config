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
  # Define your custom nvibrant package
  nvibrant_git = pkgs.callPackage (../../pkgs/nvibrant-git/default.nix) {};
  customEdid = pkgs.runCommandNoCC "custom-edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./new-edid.bin} $out/lib/firmware/edid/msi-fourk.bin
  '';
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };

  boot.kernelParams = ["pcie_aspm=off"];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  services.flatpak.enable = true;

  # Nvidia stuff
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaPersistenced = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  systemd.services.nvidia-gpu-lock = {
    description = "Lock NVIDIA GPU clocks";
    after = ["systemd-modules-load.service"];
    wantedBy = ["multi-user.target"];
    path = [config.hardware.nvidia.package];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStartPre = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lmc 5001,11201";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lgc 2105,3105";
      ExecStop = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rgc";
      ExecStopPost = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rmc";
      RemainAfterExit = true;
    };
  };

  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.variables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

  environment.systemPackages =
    [
      inputs.audselect_rs.packages.${pkgs.system}.default
      pkgs.hydra-check
      pkgs.protonup-qt
      pkgs.gamescope-wsi
      pkgs.mangohud
      pkgs.goverlay
      pkgs.redisinsight
      pkgs.lmstudio
      pkgs.opencode
      pkgs.google-cloud-sdk
    ]
    ++ lib.optionals config.myConfig.nvibrant.enable [nvibrant_git];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # For NVF
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Image hosting
  services.immich = {
    enable = true;
    port = 2283;
    openFirewall = true;
    host = "0.0.0.0";
    machine-learning.enable = true;
    machine-learning.environment = {
      HF_XET_CACHE = "/var/cache/immich/huggingface-xet";
    };
    accelerationDevices = null;
  };
  users.users.immich.extraGroups = ["video" "render"];

  nixpkgs.overlays = [
    (final: prev: {
      btop = prev.btop.override {cudaSupport = true;};

      # Pin redisinsight from working nixpkgs commit 549bd84d6279f9852cae6225e372cc67fb91a4c1 (v2.70.0)
      redisinsight = (import inputs.nixpkgs-redisinsight {
        system = final.system;
        config.allowUnfree = true;
      }).redisinsight;
    })
  ];

  myConfig = {
    nvf.companionLocal = true;
    hyprland = {
      primaryMonitor = {
        rr = 160.0;
        vrr = 3;
        tenbit = true;
        hdr = false;
      };
      secondMonitor = true;
    };
    tex.enable = true;
  };

  programs.ollama-cuda.enable = false;

  modules.services.geforcenow.enable = true;

  services.openssh.enable = true;
}
