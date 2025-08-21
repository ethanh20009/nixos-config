{lib, ...}: {
  options.myConfig = {
    hyprland = {
      secondMonitor = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable second monitor";
      };
    };
  };
}
