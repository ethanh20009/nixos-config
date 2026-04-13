{
  inputs,
  config,
  myConfig,
  ...
}: {
  imports = [
    # Import the Caelestia Home Manager module
    inputs.caelestia-shell.homeManagerModules.default
  ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      background.enabled = false;
      general = {
        idle = {
          lockBeforeSleep = true;
          inhibitWhenAudio = true;
          timeouts = [
            {
              timeout = 300;
              idleAction = "lock";
            }
            {
              timeout = 360;
              idleAction = "systemctl suspend";
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
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
