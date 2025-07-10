{ config, pkgs, inputs, ... }:
{

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
      	kb_options = caps:swapescape;
      };
    };
  };
}
