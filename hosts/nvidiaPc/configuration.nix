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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

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
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  systemd.services.nvidia-gpu-lock = {
    description = "Lock NVIDIA GPU clocks";
    after = ["systemd-modules-load.service"];
    wantedBy = ["multi-user.target"];
    path = [config.hardware.nvidia.package];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lgc 2105,3105";
      ExecStop = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rgc";
      RemainAfterExit = true;
    };
  };

  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.variables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

  environment.systemPackages = [
    inputs.audselect_rs.packages.${pkgs.system}.default
    pkgs.hydra-check
    pkgs.protonup-qt
    pkgs.gamescope-wsi
    pkgs.mangohud
    pkgs.goverlay
    pkgs.redisinsight
    pkgs.lmstudio
  ] ++ lib.optionals config.myConfig.nvibrant.enable [nvibrant_git];

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

      # Fix redisinsight pulling in insecure/EOL Node 20.
      # This overlay forces Node 22 and removes 'devEngines' from package.json which
      # causes modern npm to fail the build.
      # TODO: Remove when redisinsight is updated upstream to use a secure Node version.
      redisinsight = prev.redisinsight.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (lib.filter (p: !(lib.hasPrefix "nodejs" (p.name or ""))) (oldAttrs.nativeBuildInputs or [])) ++ [final.nodejs_22 final.jq];
        postPatch = (oldAttrs.postPatch or "") + ''
          if [ -f package.json ]; then
            jq 'del(.devEngines)' package.json > package.json.tmp && mv package.json.tmp package.json
          fi
        '';
      });
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

  programs.ollama-cuda.enable = true;
  programs.antigravity-cli.enable = true;

  services.openssh.enable = true;
}
