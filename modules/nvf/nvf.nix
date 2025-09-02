{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./alpha.nix
  ];

  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
    settings.vim = {
      extraPackages = [
        pkgs.angular-language-server
        pkgs.vtsls
        pkgs.nodePackages.vscode-langservers-extracted
        pkgs.prettierd
        pkgs.ripgrep
      ];
      startPlugins = [
        pkgs.vimPlugins.alpha-nvim
        pkgs.vimPlugins.plenary-nvim # required dependency
        pkgs.vimPlugins.vim-dadbod
        pkgs.vimPlugins.vim-dadbod-ui
        pkgs.vimPlugins.vim-dadbod-completion
      ];
      extraPlugins = with pkgs.vimPlugins; {
        grug-far = {
          package = grug-far-nvim;
        };
        crates = {
          package = crates-nvim;
          setup = ''
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
          package = luasnip;
          setup = ''
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip").filetype_extend("htmlangular", { "html" })
          '';
        };
      };

      luaConfigRC.angular = ''
        vim.filetype.add({
          pattern = {
            [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
          },
        })
      '';

      luaConfigRC.dbui = ''
        vim.g.db_ui_execute_on_save = 0
        vim.g.db_ui_auto_execute_table_helpers = 1
      '';

      luaConfigRC.virtualText = ''
        vim.diagnostic.config({virtual_text = true})
      '';

      luaConfigRC.removeDefaultBinds = ''
        vim.keymap.del("n", "gri")
        vim.keymap.del("n", "grr")
        vim.keymap.del("n", "gra")
        vim.keymap.del("n", "grc")
      '';

      options = {
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        clipboard = "unnamedplus";
        winborder = "single";
      };
      undoFile.enable = true;
      keymaps = [
        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope find_files<CR>";
          desc = "Find files with names";
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>Neotree toggle<CR>";
          desc = "Toggle Neotree filesystem show";
        }
        {
          key = "<leader>sr";
          mode = "n";
          silent = true;
          action = "<cmd>GrugFar<CR>";
          desc = "Grug Search Replace";
        }
        {
          key = "gd";
          mode = "n";
          silent = true;
          action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          desc = "Go to Definition";
        }
        {
          key = "gy";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope lsp_type_definitions<CR>";
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
        {
          key = "<C-d>";
          mode = [
            "n"
          ];
          silent = true;
          action = "<C-d>zz";
          desc = "Center after scroll";
        }
        {
          key = "<C-u>";
          mode = [
            "n"
          ];
          silent = true;
          action = "<C-u>zz";
          desc = "Center after scroll";
        }
        {
          key = "]d";
          mode = [
            "n"
          ];
          silent = true;
          action = "function() vim.diagnostic.jump({count=1, float=true}) end";
          desc = "Next Diagnostic";
          lua = true;
        }
        {
          key = "[d";
          mode = [
            "n"
          ];
          silent = true;
          action = "function() vim.diagnostic.jump({count=-1, float=true}) end";
          desc = "Prev Diagnostic";
          lua = true;
        }
        {
          key = "]e";
          mode = [
            "n"
          ];
          silent = true;
          action = "function() vim.diagnostic.jump({count=1, float=true, severity=vim.diagnostic.severity.ERROR}) end";
          desc = "Next Error";
          lua = true;
        }
        {
          key = "[e";
          mode = [
            "n"
          ];
          silent = true;
          action = "function() vim.diagnostic.jump({count=-1, float=true, severity=vim.diagnostic.severity.ERROR}) end";
          desc = "Prev Error";
          lua = true;
        }
        {
          key = "<leader>gv";
          mode = [
            "n"
          ];
          silent = true;
          action = "<cmd>DiffviewOpen<CR>";
          desc = "Diffview";
        }
        {
          key = "<leader>gd";
          mode = [
            "n"
          ];
          action = "<cmd>DiffviewClose<CR>";
          desc = "Diffview close";
        }
        {
          key = "<leader>gm";
          mode = "n";
          action = ''
            function()
              local file = io.popen("git merge-base HEAD master", "r")
              if not file then return end
              local output = file:read("*a"):gsub("[\n\r]$", "")
              file:close()
              vim.cmd(":DiffviewOpen --staged " .. output)
            end
          '';
          lua = true;
          desc = "Compare with branch";
        }
        {
          key = "<leader>ud";
          mode = "n";
          lua = true;
          action = ''
            function()
              local new_config = not vim.diagnostic.config().virtual_text
              vim.diagnostic.config({virtual_text = new_config})
            end
          '';
          desc = "Toggle Virtual Lines";
        }
        {
          key = "gr";
          mode = "n";
          action = "<cmd>Telescope lsp_references<CR>";
          desc = "References";
        }
        {
          key = "gI";
          mode = "n";
          action = "<cmd>Telescope lsp_implementations<CR>";
          desc = "Implementations";
        }
        {
          key = "<leader>cr";
          mode = "n";
          lua = true;
          action = ''
            function()
              vim.lsp.buf.rename()
            end
          '';
          desc = "LSP Rename";
        }
        {
          key = "<leader>D";
          mode = "n";
          action = "<cmd>DBUIToggle<CR>";
          desc = "Toggle Dadbod UI";
        }
        {
          key = "<leader>bo";
          mode = "n";
          action = "<cmd>BufferLineCloseOthers<CR>";
          desc = "Close others";
        }
      ];
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
            # ReOrder the tabs
            # moveNext = "<leader>me";
            # movePrevious = "<leader>mq";
          };
        };
      };
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        angular
        typescript
        html
      ];
      formatter.conform-nvim = {
        enable = true;
        setupOpts.formatters_by_ft = {
          htmlangular = [
            "prettierd"
          ];
          html = [
            "prettierd"
          ];
          typescript = [
            "prettierd"
          ];
        };
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        scala.enable = true;
        markdown.enable = true;
        rust = {
          enable = true;
          crates = {
            enable = true;
            codeActions = true;
          };
          format.enable = true;
          format.type = "rustfmt";
          lsp = {
            enable = true;
            opts = "
            ['rust-analyzer'] = {
              cargo = {allFeature = true},
              checkOnSave = true;
              procMacro = {
                enable =true;
              },
            },
            ";
          };
        };
      };
      # clipboard = {
      #   enable = true;
      #   providers.wl-copy.enable = true;
      # };
      telescope = {
        enable = true;
        mappings = {
          gitStatus = "<leader>gs";
          liveGrep = "<leader>sg";
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        mappings = {
          openDiagnosticFloat = "<leader>cd";
          goToType = null;
          goToDefinition = null;
          goToDeclaration = null;
          codeAction = null;
        };

        servers = {
          angularls = {};
          vtsls = {};
          html = {
            filetypes = [
              "htmlangular"
              "html"
            ];
          };
        };
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
      diagnostics.config.virtual_text = true;
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
          command = "silent! lua vim.hl.on_yank {higroup='IncSearch', timeout=100}";
        }
      ];

      autocomplete = {
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "default";
            snippets = {preset = "luasnip";};
            sources = {
              providers = {
                buffer = {
                  score_offset = -10;
                };
              };
            };
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
      treesitter.mappings = {
        incrementalSelection = {
          incrementByNode = "<C-n>";
          decrementByNode = "<C-p>";
        };
      };
      treesitter.textobjects = {
        enable = true;
        setupOpts = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              af = "@function.outer";
              "if" = "@function.inner";
            };
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
          # theme = "tokyonight";
        };
      };
      dashboard = {
        alpha.enable = true;
      };
      mini.surround = {
        enable = true;
        setupOpts = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
      utility = {
        diffview-nvim.enable = true;
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
