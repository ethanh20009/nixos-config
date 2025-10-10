{
  myConfig,
  pkgs,
  lib,
  config,
  ...
}: let
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-tetex
      dvisvgm
      dvipng
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      latexmk
      moderncv
      fontawesome5
      xpatch
      xcolor
      ;
  };
in {
  config = lib.mkMerge [
    (lib.mkIf myConfig.tex.enable {
      home.packages = with pkgs; [
        tex
        lmodern
      ];
      programs.nvf.settings.vim = {
        extraPackages = [
          pkgs.ltex-ls
        ];
        startPlugins = [
          pkgs.vimPlugins.vimtex
        ];
      };
    })
  ];
}
