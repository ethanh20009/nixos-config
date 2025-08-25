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
    ../../modules/options.nix
    ../../modules/default_pkgs.nix
  ];

  stylix.enable = true;
  stylix.image = ../../wallpapers/colorful-planets.jpg;
  stylix.polarity = "dark";
  stylix.targets.nvf.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.systemd-boot.windows = {
    "11" = {
      title = "Windows 11";
      efiDeviceHandle = "HD3b";
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethan = {
    isNormalUser = true;
    description = "Ethan";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      myConfig = config.myConfig;
    };
    users = {
      "ethan" = import ../../home/home.nix;
    };
  };

  fonts = {
    fontDir.enable = true; # Recommended for better font discovery
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code # Popular for monospace
      # If you want Nerd Fonts (highly recommended for icons/glyphs)
      # You can add individual ones:
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      # You can set default fonts for different families here.
      # This is often where you control system-wide font fallback.
      defaultFonts = {
        serif = ["Liberation Serif"];
        monospace = ["Fira Code Nerd Font" "FiraCode Nerd Font"];
      };
      # You might also want to enable font hinting and antialiasing
      # (often default, but good to know)
      hinting.autohint = true;
      antialias = true;
    };
  };

  # Nvidia stuff
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = config.myConfig.defaultPackages;

  programs.hyprland.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # For hyprpanel
  services.upower.enable = true;

  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # For NVF
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  myConfig.hyprland = {
    secondMonitor = true;
  };
}
