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
      paths = {
        wallpaperDir = ../../wallpapers;
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
