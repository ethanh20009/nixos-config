{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      startPlugins = [
        pkgs.vimPlugins.alpha-nvim
        pkgs.vimPlugins.plenary-nvim # required dependency
      ];

      pluginRC.alpha = ''
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
          dashboard.button("n", "  New file", ":ene | startinsert<CR>"),
          dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
          dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
          dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
          dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
          dashboard.button("s", "  Previous Session", ":SessionManager load_last_session<CR>"),
          dashboard.button("q", "  Quit", ":qa<CR>")
        }

        dashboard.section.footer.val = {"Blazingly Fast"}

        dashboard.config.layout = {
          {type = "padding", val = 0},
          dashboard.section.header,
          {type = "padding", val = 0},
          {
            type = "group",
            val = dashboard.section.buttons.val,
            opts = {
              position = "center",
              spacing = 0
            }
          },
          { type = "padding", val = 0},
          dashboard.section.footer,
        }

        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.opts)
      '';
      options = {
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        clipboard = "unnamedplus";
      };
      keymaps = [
        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope find_files<CR>";
          desc = "Find files with names";
        }
        {
          key = "<leader>fp";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope projects<CR>";
          desc = "Find Projects";
        }
        {
          key = "<leader>fm";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope media_files<CR>";
          desc = "Find Media Files";
        }
        {
          key = "<leader>fb";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope file_browser<CR>";
          desc = "File Browser";
        }
        {
          key = "<leader>fg";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope live_grep<CR>";
          desc = "Find files with Contents FZF";
        }
        {
          key = "<leader>nn";
          mode = "n";
          silent = true;
          action = "<cmd>Neotree toggle<CR>";
          desc = "Toggle Neotree filesystem show";
        }
        {
          key = "<K>";
          mode = "n";
          silent = true;
          action = "<cmd>vim.lsp.buf.hover<CR>";
          desc = "Hover Documentation";
        }
        {
          key = "gd";
          mode = "n";
          silent = true;
          action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          desc = "Go to Definition";
        }
        {
          key = "<leader>ca";
          mode = "n";
          silent = true;
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          desc = "LSP Code Action (Normal)";
        }
        {
          key = "<leader>ca";
          mode = "v";
          silent = true;
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          desc = "LSP Code Action (Visual)";
        }
        {
          key = "<leader>sm";
          mode = "n";
          silent = true;
          action = "<cmd>Session<CR>";
          desc = "Open Session Manager";
        }
        # Smart Split Keybinds
        {
          key = "<leader>wv";
          mode = "n";
          silent = true;
          action = "<cmd>vsplit<CR>";
          desc = "Split Vertical";
        }
        {
          key = "<leader>wh";
          mode = "n";
          silent = true;
          action = "<cmd>split<CR>";
          desc = "Split Horizontal";
        }
        {
          key = "<leader>wq";
          mode = "n";
          silent = true;
          action = "<cmd>q<CR>";
          desc = "Close Split";
        }
        # {
        #   key = "<leader>ht";
        #   mode = "n";
        #   silent = true;
        #   action = "<cmd>Hardtime toggle<CR>";
        #   desc = "Toggle HardTime";
        # }
        {
          key = "<leader>tc";
          mode = "n";
          silent = true;
          action = "<cmd>TSContext toggle<CR>";
          desc = "Toggle the Treesitter context";
        }
        {
          key = "<leader>tt";
          mode = [
            "n"
            "t"
          ];
          silent = true;
          action = "<cmd>FloatermToggle<CR>";
          desc = "Toggle Floaterm";
        }
        {
          key = "-";
          mode = [
            "n"
          ];
          silent = true;
          action = "<cmd>Oil<CR>";
          desc = "Oil";
        }
      ];
      theme = {
        enable = true;
        name = "tokyonight";
        style = "storm";
      };
      tabline = {
        nvimBufferline = {
          enable = true;
          mappings = {
            cycleNext = "L";
            cyclePrevious = "H";
            closeCurrent = "<leader>bd";
            pick = "<leader>bp";
            # ReOrder the tabs
            # moveNext = "<leader>me";
            # movePrevious = "<leader>mq";
          };
        };
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
        # nvim-cursorline.enable = true;
        # cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;

        # highlight-undo.enable = true;
        indent-blankline.enable = true;

        # Fun
        cellular-automaton.enable = false;
      };
      autopairs.nvim-autopairs.enable = true;

      session.nvim-session-manager = {
        enable = true;
        usePicker = true;
        mappings = {
          deleteSession = "<leader>sd";
          loadLastSession = "<leader>slt";
          saveCurrentSession = "<leader>sc";
        };
        setupOpts = {
          autoload_mode = "Disabled";
          autosave_last_session = true;
          autosave_ignore_buftypes = [
            "terminal"
            "quickfix"
            "nofile"
            "help"
          ];

          autosave_ignore_dirs = [
            "~/"
            "~/Projects"
            "~/Downloads/"
            "~/temp"
            "/tmp"
          ];
        };
      };

      autocmds = [
        {
          desc = "Highlight yanked lines";
          enable = true;
          event = ["TextYankPost"];
          pattern = ["*"];
          command = "silent! lua vim.hl.on_yank {higroup='Visual', timeout=100}";
        }
      ];

      autocomplete = {
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "default";
          };
        };
        nvim-cmp.enable = false;
      };
      filetree = {
        neo-tree = {
          enable = true;
        };
      };
      # treesitter.context.enable = true;
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
      dashboard = {
        alpha.enable = true;
      };
      utility = {
        diffview-nvim.enable = true;
        surround.enable = true;
        oil-nvim.enable = true;

        motion.flash-nvim = {
          enable = true;
          mappings = {
            jump = "s"; # jump key
            remote = "r"; # remote jump
            toggle = "<c-s>"; # toggle search
          };
          setupOpts = {}; # use defaults, optional
        };
        smart-splits = {
          enable = true;

          keymaps = {
            move_cursor_down = "<C-j>";
            move_cursor_left = "<C-h>";
            move_cursor_right = "<C-l>";
            move_cursor_up = "<C-k>";
            move_cursor_previous = "<C-\\>";

            resize_down = "<A-j>";
            resize_left = "<A-h>";
            resize_right = "<A-l>";
            resize_up = "<A-k>";

            swap_buf_down = "<leader><leader>j";
            swap_buf_left = "<leader><leader>h";
            swap_buf_right = "<leader><leader>l";
            swap_buf_up = "<leader><leader>k";
          };

          # Optional extra options passed to smart-splits.setup()
          setupOpts = {};
        };
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
