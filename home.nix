{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ethan";
  home.homeDirectory = "/home/ethan";

  imports = [
    inputs.nvf.homeManagerModules.default
    ./hyprpanel.nix
    ./hyprland.nix
    ./nvf.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.hide_env_diff = true;
  };

  programs.firefox.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.power-profiles-daemon
    pkgs.nil
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ethan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    TEST = "Hello";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Ethan Howard";
    userEmail = "ethanh20009@outlook.com";
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      "v" = "nvim";
      "bt" = "btop";
      "c" = "clear";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
  home.shell.enableFishIntegration = true;

  programs.starship.enable = true;

  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.5";
      background_blur = 5;
      font_family = "Fira Code Nerd Font Mono"; # Use the exact name of the font
      font_size = 12.0;
      # symbol_map = let
      #   mappings = [
      #     "U+23FB-U+23FE"
      #     "U+2B58"
      #     "U+E200-U+E2A9"
      #     "U+E0A0-U+E0A3"
      #     "U+E0B0-U+E0BF"
      #     "U+E0C0-U+E0C8"
      #     "U+E0CC-U+E0CF"
      #     "U+E0D0-U+E0D2"
      #     "U+E0D4"
      #     "U+E700-U+E7C5"
      #     "U+F000-U+F2E0"
      #     "U+2665"
      #     "U+26A1"
      #     "U+F400-U+F4A8"
      #     "U+F67C"
      #     "U+E000-U+E00A"
      #     "U+F300-U+F313"
      #     "U+E5FA-U+E62B"
      #   ];
      # in
      #   (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
  programs.bash = {
    enable = true;
  };
}
