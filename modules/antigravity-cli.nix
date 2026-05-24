# TODO: Remove this module when antigravity-cli is upstreamed in nixpkgs
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.antigravity-cli;
  antigravity-cli = pkgs.callPackage ../pkgs/antigravity-cli/default.nix {};
in {
  options.programs.antigravity-cli = {
    enable = lib.mkEnableOption "Antigravity CLI - A powerful tool for agentic workflows";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      antigravity-cli
    ];
  };
}
