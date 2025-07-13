{
  config,
  lib,
  ...
}: {
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = false;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.7";
      background_blur = 5;
      font_family = "Fira Code Nerd Font Mono"; # Use the exact name of the font
      font_size = 12.0;
    };
  };
}
