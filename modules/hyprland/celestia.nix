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
      general = {
        idle = {
          lockBeforeSleep = false;
          inhibitWhenAudio = false;
          timeouts = [
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
