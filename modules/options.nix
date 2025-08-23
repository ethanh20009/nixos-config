{lib, ...}: {
  options.myConfig = {
    hyprland = {
      secondMonitor = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable second monitor";
      };
      touchpadDevices = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [];
        description = "List of touchpad devices from 'hyprctl devices'.
        Will use adaptive accel profile.";
      };
    };
  };
}
