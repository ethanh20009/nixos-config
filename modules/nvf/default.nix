{
  config,
  lib,
  pkgs,
  myConfig,
  ...
}: let
  cfg = myConfig.nvf;
in {
  imports = [
    ./alpha.nix
    ./handlebars.nix
    ./companion.nix
    ./keymaps.nix
    ./languages.nix
    ./plugins.nix
    ./settings.nix
    ./ui.nix
  ];

  config = lib.mkIf cfg.enable {
    stylix.targets.nvf.enable = false;
    programs.nvf.enable = true;
  };
}
