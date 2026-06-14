{
  pkgs,
  lib,
  config,
  inputs,
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
      nh
      lsof
      moreutils
      spotify
      hyprpicker
      easyeffects
      qpwgraph
      ldacbt
      unzip
      claude-code
      ncdu
      nodejs
      vlc
      antigravity-cli
      kdePackages.okular
    ]
    ++ lib.optional config.myConfig.extras.deno.enable pkgs.deno;
in {
  imports = [
    ../ollama-cuda.nix
    ../options.nix
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
      experimental-features = ["nix-command" "flakes"];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    stylix.image = config.myConfig.wallpaper;
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.targets.nvf.enable = false;
    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = config.myConfig.defaultPackages;

    programs.gpu-screen-recorder.enable = true;
    security.polkit.enable = true;

    # Bluetooth
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Networking
    networking.networkmanager.enable = true;

    # Time and Locale
    time.timeZone = "Europe/London";
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

    # Keymaps
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };
    console.keyMap = "uk";

    # User
    users.users.ethan = {
      isNormalUser = true;
      description = "Ethan";
      extraGroups = ["networkmanager" "wheel" "docker" "adbusers" "gamemode" "video" "render"];
      shell = pkgs.fish;
    };

    # Home Manager Setup
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
        myConfig = config.myConfig;
      };
      users = {
        "ethan" = {
          imports = [../../home/home.nix];
        };
      };
    };

    # Fonts
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
      fontconfig = {
        # defaultFonts = {
        #   serif = ["Liberation Serif"];
        #   monospace = ["Fira Code Nerd Font" "FiraCode Nerd Font"];
        # };
        hinting.autohint = true;
        antialias = true;
      };
    };

    # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Common Programs & Services
    programs.fish.enable = true;
    programs.hyprland.enable = true;

    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    services.upower.enable = true;
    virtualisation.docker.enable = true;

    system.stateVersion = "25.05";
  };
}
