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
      options = {
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        ignorecase = true;
        smartcase = true;
        clipboard = "unnamedplus";
        winborder = "single";
        wrap = false;
      };

      undoFile.enable = true;

      diagnostics.config.virtual_text = true;
      autopairs.nvim-autopairs.enable = true;

      autocmds = [
        {
          desc = "Highlight yanked lines";
          enable = true;
          event = ["TextYankPost"];
          pattern = ["*"];
          command = "silent! lua vim.hl.on_yank {higroup='IncSearch', timeout=100}";
        }
      ];

      assistant.copilot = {
        enable = true;
        cmp.enable = false;
        setupOpts = {
          suggestion.auto_trigger = false;
          filetypes = {
            sh = lib.generators.mkLuaInline ''
              function ()
                if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                  -- disable for .env files
                  return false
                end
                return true
              end,
            '';
          };
        };
      };

      notes.obsidian = {
        enable = true;
        setupOpts.workspaces = [
          {
            name = "personal";
            path = "~/personal";
          }
        ];
      };

      filetree.neo-tree.enable = true;
      treesitter.enable = true;
      treesitter.fold = true;
      treesitter.highlight.enable = true;
      treesitter.indent.enable = true;
      treesitter.textobjects = {
        enable = false;
        setupOpts.select = {
          enable = true;
          lookahead = true;
          keymaps = {
            af = "@function.outer";
            "if" = "@function.inner";
          };
        };
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };

      terminal.toggleterm.enable = true;

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

      telescope = {
        enable = true;
        mappings = {
          gitStatus = "<leader>gs";
          liveGrep = "<leader>sg";
        };
        setupOpts = {
          defaults = {
            layout_config.horizontal = {
              prompt_position = "top";
            };
            sorting_strategy = "ascending";
            vimgrep_arguments = [
              "${pkgs.ripgrep}/bin/rg"
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
              "--smart-case"
            ];
          };
        };
      };

      mini.surround = {
        enable = true;
        setupOpts.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };

      utility = {
        snacks-nvim = {
          enable = true;
          setupOpts = {
            bigfile.enabled = true;
            lazygit.configure = true;
          };
        };
        diffview-nvim.enable = true;
        oil-nvim.enable = true;

        motion.flash-nvim = {
          enable = true;
          mappings = {
            jump = "s";
            remote = "r";
            toggle = "<c-s>";
          };
        };

        smart-splits = {
          enable = true;
          keymaps = {
            move_cursor_down = "<C-j>";
            move_cursor_left = "<C-h>";
            move_cursor_right = "<C-l>";
            move_cursor_up = "<C-k>";
            move_cursor_previous = "<C-\\>";

            resize_down = "<C-J>";
            resize_left = "<C-H>";
            resize_right = "<C-L>";
            resize_up = "<C-K>";

            swap_buf_down = "<leader><leader>j";
            swap_buf_left = "<leader><leader>h";
            swap_buf_right = "<leader><leader>l";
            swap_buf_up = "<leader><leader>k";
          };
        };
      };

      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      luaConfigRC = {
        angular = ''
          vim.filetype.add({
            pattern = {
              [".*%.component%.html"] = "htmlangular",
            },
          })
        '';

        dbui = ''
          vim.g.db_ui_execute_on_save = 0
          vim.g.db_ui_auto_execute_table_helpers = 1
        '';

        virtualText = ''
          vim.diagnostic.config({virtual_text = true})
        '';

        folds = ''
          vim.o.foldlevel = 99
          vim.o.foldlevelstart = 99
        '';

        removeDefaultBinds = ''
          vim.keymap.del("n", "gri")
          vim.keymap.del("n", "grr")
          vim.keymap.del("n", "gra")
          vim.keymap.del("n", "grn")
          vim.keymap.del("n", "grt")
        '';
      };
    };
  };
}
