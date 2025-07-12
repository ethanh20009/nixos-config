{...}: {
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
    };
  };
}
