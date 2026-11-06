{
  inputs,
  config,
  pkgs,
  myConfig,
  ...
}: let
  # TODO: Remove this override once fixed upstream in caelestia-dots/cli:
  # Upstream default.nix sets `SETUPTOOLS_SCM_PRETEND_VERSION = 1;` which is an integer and
  # not exported to the Python wheel build subprocess under Nixpkgs structured attributes.
  # Tracked / Issues: https://github.com/caelestia-dots/cli/issues
  caelestia-cli = inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.system}.default.overrideAttrs (old: {
    env =
      (old.env or {})
      // {
        SETUPTOOLS_SCM_PRETEND_VERSION_FOR_CAELESTIA = "0.1.0";
      };
    preBuild =
      (old.preBuild or "")
      + ''
        export SETUPTOOLS_SCM_PRETEND_VERSION="0.1.0"
      '';
  });
  caelestia-shell = inputs.caelestia-shell.packages.${pkgs.system}.caelestia-shell.override {
    inherit caelestia-cli;
    withCli = true;
  };
in {
  imports = [
    # Import the Caelestia Home Manager module
    inputs.caelestia-shell.homeManagerModules.default
  ];
  programs.caelestia = {
    enable = true;
    package = caelestia-shell;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
      environment = [];
    };
    settings = {
      background.enabled = false;
      general = {
        idle = {
          lockBeforeSleep = false;
          inhibitWhenAudio = false;
          # Only define a display-off action; no lock or suspend timeout is configured.
          timeouts = [
            {
              timeout = 300;
              idleAction = "dpms off";
              returnAction = "dpms on";
            }
          ];
        };
      };
      paths = {
        wallpaperDir = ../../wallpapers;
        sessionGif = ../../wallpapers/coding-animated.gif;
      };
      bar = {
        clock = {
          showIcon = true;
        };
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      package = caelestia-cli;
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
