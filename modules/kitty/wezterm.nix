{
  config,
  lib,
  ...
}: {
  programs.wezterm = lib.mkForce {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("Fira Code Nerd Font Mono"),
        font_size = 12.0,
        window_background_opacity = 0.7,
        enable_tab_bar = false,
        front_end = "WebGpu",
        default_cursor_style = "SteadyBar",
        warn_about_missing_glyphs = false,
        keys = {
        }
      }
    '';
  };
}
