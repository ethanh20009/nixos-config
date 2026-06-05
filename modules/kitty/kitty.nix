{
  config,
  lib,
  myConfig,
  ...
}: let
  cfg = myConfig;
in {
  config = lib.mkIf (cfg.terminal == "kitty") {
    programs.kitty = lib.mkForce {
      enable = true;
      extraConfig = ''
        confirm_os_window_close 0
        dynamic_background_opacity no
        enable_audio_bell no
        mouse_hide_wait -1.0
        window_padding_width 10
        background_opacity 0.7
        background_blur 5
        font_size 12.0
        auto_reload_config -1
      '';
      settings = {
      };
    };
  };
}
