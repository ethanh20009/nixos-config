{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      options = {
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        clipboard = "unnamedplus";
      };
      theme = {
        enable = true;
        name = "tokyonight";
        style = "storm";
      };
      tabline = {
        nvimBufferline.enable = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        markdown.enable = true;
      };
      # clipboard = {
      #   enable = true;
      #   providers.wl-copy.enable = true;
      # };
      telescope.enable = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
      };

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;

        highlight-undo.enable = true;
        indent-blankline.enable = true;

        # Fun
        cellular-automaton.enable = false;
      };
      autopairs.nvim-autopairs.enable = true;

      autocomplete = {
        blink-cmp.enable = true;
      };
      filetree = {
        neo-tree = {
          enable = true;
        };
      };
      treesitter.context.enable = true;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };

      terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };
      statusline = {
        lualine = {
          enable = true;
          theme = "tokyonight";
        };
      };
      utility = {
        diffview-nvim.enable = true;
        surround.enable = true;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };
    };
  };
}
