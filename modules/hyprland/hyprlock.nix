{config, ...}: let
  # Assign a shorthand for the Stylix generated palette
  # When using stylix.image, the generated colors are typically in config.stylix.generated.palette
  # If you were using stylix.base16Scheme, it would be config.lib.stylix.colors
  stylixColors = config.stylix.generated.palette;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        # grace = 300;
        hide_cursor = false;
      };

      # background = [
      #   {
      #     # path = "screenshot";
      #     # blur_passes = 3;
      #     # blur_size = 8;
      #   }
      # ];

      # input-field = [
      #   {
      #     size = "200, 50";
      #     position = "0, -80";
      #     monitor = "";
      #     dots_center = true;
      #     fade_on_empty = false;
      #     outline_thickness = 5;
      #     placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
      #     shadow_passes = 2;
      #   }
      # ];

      label = with stylixColors; [
        {
          size = "200, 50";
          position = "0, 100";
          monitor = "";
          text = "cmd[update:1000] echo \"<span foreground='##${base05}'>$(date +\"%a %d %b %H:%M\")</span>\"";
          font_size = 20;
        }
      ];
    };
  };
}
