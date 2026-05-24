{
  config,
  pkgs,
  lib,
  myConfig,
  ...
}: let
  cfg = myConfig.nvf;
in {
  config = lib.mkIf cfg.enable {
    programs.nvf.settings.vim = {
      theme = {
        enable = true;
        name = "tokyonight";
        style = "moon";
        transparent = true;
      };

      tabline = {
        nvimBufferline = {
          enable = true;
          mappings = {
            cycleNext = "L";
            cyclePrevious = "H";
            closeCurrent = "<leader>bd";
            pick = "<leader>bp";
          };
        };
      };

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        fidget-nvim.enable = true;
        indent-blankline.enable = true;
        cellular-automaton.enable = false;
      };

      statusline.lualine = {
        enable = true;
      };

      dashboard.alpha.enable = true;

      ui = {
        nvim-ufo.enable = true;

        noice = {
          enable = true;
          setupOpts = {
            presets = {
              lsp_doc_border = true;
            };
            lsp = {
              hover.enabled = false;
              signature.enabled = true;
            };
            routes = [
              {
                filter = {
                  event = "notify";
                  find = "Could not find source";
                };
                opts = {skip = true;};
              }
              {
                filter = {
                  event = "notify";
                  find = "Request textDocument/inlayHint failed";
                };
                opts = {skip = true;};
              }
            ];
          };
        };
      };
    };
  };
}
