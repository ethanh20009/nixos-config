{
  config,
  pkgs,
  inputs,
  lib,
  myConfig,
  ...
}: let
  cfg = myConfig.nvf;
  nvf-pkgs = import inputs.nvf.inputs.nixpkgs {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  config = lib.mkIf cfg.enable {
    programs.nvf.settings.vim = {
      extraPackages = [
        nvf-pkgs.angular-language-server
        nvf-pkgs.vtsls
        nvf-pkgs.vscode-langservers-extracted
        nvf-pkgs.prettierd
        nvf-pkgs.ripgrep
        nvf-pkgs.lazygit
        nvf-pkgs.copilot-language-server
        nvf-pkgs.lldb
        nvf-pkgs.vscode-extensions.vadimcn.vscode-lldb
        nvf-pkgs.pyright
        nvf-pkgs.black
      ];

      startPlugins = [
        nvf-pkgs.vimPlugins.alpha-nvim
        nvf-pkgs.vimPlugins.plenary-nvim
        nvf-pkgs.vimPlugins.vim-dadbod
        nvf-pkgs.vimPlugins.vim-dadbod-ui
        nvf-pkgs.vimPlugins.vim-dadbod-completion
        nvf-pkgs.vimPlugins.vim-mustache-handlebars
        nvf-pkgs.vimPlugins.nvim-dap-lldb
        nvf-pkgs.vimPlugins.markdown-preview-nvim
      ];

      extraPlugins = {
        grug-far = {
          package = pkgs.vimPlugins.grug-far-nvim;
        };
        vim-abolish = {
          package = pkgs.vimPlugins.vim-abolish;
        };
        crates = {
          package = pkgs.vimPlugins.crates-nvim;
          setup =
            /*
            lua
            */
            ''
              require('crates').setup({
                completion = {
                  crates = {
                    enabled = true,
                  },
                },
                lsp = {
                  enabled = true,
                  actions = true,
                  completion = true,
                  hover = true,
                },
              })
            '';
        };
        luasnip = {
          package = pkgs.vimPlugins.luasnip;
          setup =
            /*
            lua
            */
            ''
              require("luasnip.loaders.from_vscode").lazy_load()
              require("luasnip").filetype_extend("htmlangular", { "html" })
              require("luasnip").filetype_extend("tsx", { "html" })
              require("luasnip.loaders.from_vscode").lazy_load({ paths = { "${./snippets}" } })
            '';
        };
      };

      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        nix
        lua
        angular
        html
        json
        javascript
        rust
        typescript
        tsx
        yaml
        python
      ];
    };
  };
}
