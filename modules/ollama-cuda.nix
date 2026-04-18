{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ollama-cuda;
in {
  options.programs.ollama-cuda = {
    enable = lib.mkEnableOption "Standalone ollama setup";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.ollama-cuda];

    nix.settings = {
      extra-substituters = ["https://cache.nixos-cuda.org"];
      extra-trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
    };

    nixpkgs.config.allowUnfree = true;
  };
}
