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
    ../../modules/shared-system.nix
  ];

  stylix.enable = true;
  stylix.image = ../../wallpapers/colorful-planets.jpg;
  stylix.polarity = "dark";
  stylix.targets.nvf.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5b878c3f-b319-4854-9886-7094e13b5a45".device = "/dev/disk/by-uuid/5b878c3f-b319-4854-9886-7094e13b5a45";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

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

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;
    };
  };
  # services.power-profiles-daemon.enable = true;

  services.logind = {
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitch = "suspend";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethan = {
    isNormalUser = true;
    description = "Ethan";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    config.myConfig.defaultPackages
    ++ (with pkgs; [
      slack
      google-cloud-sdk
      networkmanagerapplet
      getopt
    ]);
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  programs.hyprland = {
    enable = true;
    # xwayland.enable = true;
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.extraHosts = ''
    127.0.0.1 collect.flexys.dev collaborate.flexys.dev keycloak.flexys.dev engine.flexys.dev schema-registry brand1.flexys.dev brand2.flexys.dev broker keycloak
  '';

  myConfig = {
    hyprland = {
      secondMonitor = true;
    };
    extras.deno.enable = true;
    work = true;
  };
}
