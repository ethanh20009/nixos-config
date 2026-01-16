{
  config,
  pkgs,
  inputs,
  lib,
  myConfig,
  ...
}: let
  base-json-ls-settings = {
    init_options = {
      provideFormatter = false;
    };
    settings = {
      json = {
        validate = {enable = true;};
        format = {
          enable = false;
        };
      };
    };
  };
in {
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
        pkgs.lazygit
        pkgs.copilot-language-server
        pkgs.lldb
        pkgs.vscode-extensions.vadimcn.vscode-lldb
      ];
      startPlugins =
        [
          pkgs.vimPlugins.alpha-nvim
          pkgs.vimPlugins.plenary-nvim # required dependency
          pkgs.vimPlugins.vim-dadbod
          pkgs.vimPlugins.vim-dadbod-ui
          pkgs.vimPlugins.vim-dadbod-completion
          pkgs.vimPlugins.vim-mustache-handlebars
          pkgs.vimPlugins.nvim-dap-lldb
          pkgs.vimPlugins.markdown-preview-nvim
        ]
        ++ (with pkgs.vimPlugins.nvim-treesitter.queries; [
          angular
          typescript
          html
          html_tags
          ecma
          css
          rust
          javascript
          lua
          nix
          glimmer
        ]);

      lazy.plugins = {
        "sidekick.nvim" = {
          package = pkgs.vimPlugins.sidekick-nvim;
          setupModule = "sidekick";
          lazy = true;
          event = [
            {
              event = "User";
              pattern = "LazyFile";
            }
          ];
          setupOpts = {
            nes.enabled = false;
          };
          keys = let
            tool = "gemini";
          in [
            {
              key = "<leader>at";
              mode = "n";
              action = ":Sidekick cli toggle name=${tool}<CR>";
            }
            {
              key = "<leader>aa";
              mode = "n";
              action = ":Sidekick cli send prompt=file name=${tool}<CR>";
            }
            {
              key = "<leader>ap";
              mode = "n";
              action = ":Sidekick cli prompt name=${tool}<CR>";
            }
            {
              key = "<leader>ad";
              mode = "n";
              action = ":Sidekick cli send prompt=diagnostic name=${tool}<CR>";
            }
            {
              key = "<leader>aa";
              action =
                /*
                lua
                */
                ''
                  function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                  end
                '';
              mode = "x";
              lua = true;
            }
          ];
          # setupOpts = {
          #   nes.enabled = false;
          # };
        };
      };
      extraPlugins = with pkgs.vimPlugins; {
        # nvim-html-css = {
        #   package = pkgs.vimUtils.buildVimPlugin {
        #     name = "nvim-html-css";
        #     src = pkgs.fetchFromGitHub {
        #       owner = "Jezda1337";
        #       repo = "nvim-html-css";
        #       rev = "main";
        #       sha256 = "sha256-7GdPWBexJ8JzO3GwrYudqGTW8fl38EY50fzCCDIEPe0=";
        #     };
        #   };
        # };
        grug-far = {
          package = grug-far-nvim;
        };
        vim-abolish = {
          package = vim-abolish;
        };
        crates = {
          package = crates-nvim;
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
          package = luasnip;
          setup =
            /*
            lua
            */
            ''
              require("luasnip.loaders.from_vscode").lazy_load()
              require("luasnip").filetype_extend("htmlangular", { "html" })
              require("luasnip.loaders.from_vscode").lazy_load({ paths = { "${./snippets}" } })
            '';
        };
      };

      luaConfigRC.angular =
        /*
        lua
        */
        ''
          vim.filetype.add({
            pattern = {
              [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
            },
          })
        '';

      luaConfigRC.dbui =
        /*
        lua
        */
        ''
          vim.g.db_ui_execute_on_save = 0
          vim.g.db_ui_auto_execute_table_helpers = 1
        '';

      luaConfigRC.virtualText =
        /*
        lua
        */
        ''
          vim.diagnostic.config({virtual_text = true})
        '';

      luaConfigRC.folds = ''
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
      '';

      luaConfigRC.removeDefaultBinds =
        /*
        lua
        */
        ''
          vim.keymap.del("n", "gri")
          vim.keymap.del("n", "grr")
          vim.keymap.del("n", "gra")
          vim.keymap.del("n", "grn")
          vim.keymap.del("n", "grt")
        '';

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

      ui.nvim-ufo = {
        enable = true;
      };

      notes.obsidian = {
        enable = true;
        setupOpts = {
          workspaces = [
            {
              name = "personal";
              path = "~/personal";
            }
          ];
        };
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
          key = "<C-k>";
          mode = "i";
          silent = true;
          action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
          desc = "Signature help";
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
          action =
            /*
            lua
            */
            ''
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
          key = "<leader>uh";
          mode = "n";
          lua = true;
          action = ''
            function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end
          '';
          desc = "Toggle Virtual Lines";
        }
        {
          key = ">";
          mode = "v";
          action = ">gv";
          desc = "indent";
        }
        {
          key = "<";
          mode = "v";
          action = "<gv";
          desc = "unindent";
        }
        {
          key = "gr";
          mode = "n";
          action = ''
            function() Snacks.picker.lsp_references() end
          '';
          lua = true;
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
          silent = true;
          desc = "Toggle Dadbod UI";
        }
        {
          key = "<leader>bo";
          mode = "n";
          action = ''
            function()
              Snacks.bufdelete.other(opts)
            end
          '';
          lua = true;
          silent = true;
          desc = "Close others";
        }
        {
          key = "<esc>";
          mode = ["n" "i" "v"];
          action = "<cmd>noh<CR><esc>";
          desc = "Clear highlight";
        }
        {
          key = "<leader>gg";
          mode = ["n"];
          action = ''
            function()
              Snacks.lazygit()
            end
          '';
          lua = true;
          desc = "Lazygit";
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

      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        nix
        lua
        angular
        html
        json
        javascript
        rust
        typescript
        glimmer
      ];

      luaConfigRC.treesitter =
        /*
        lua
        */
        ''
          local ts_group = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true })
          local standard_indent = { 'nix', 'lua', 'html.handlebars', 'handlebars'}
          vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'nix', 'lua', 'angular', 'typescript', 'ts', 'javascript', 'html', 'json', 'rust', 'js', 'htmlangular', 'html.handlebars', 'handlebars' },
            group = ts_group,
            callback = function()
              pcall(vim.treesitter.start)
              if vim.tbl_contains(standard_indent, vim.bo.filetype) then
                vim.bo.indentexpr = ""
              end
            end,
          })
        '';

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
          json = [
            "prettierd"
          ];
        };
      };

      treesitter.enable = true;

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        scala.enable = true;
        markdown.enable = true;
        tailwind.enable = true;
        css.enable = true;
        rust = {
          enable = true;
          extensions = {
            crates-nvim.enable = true;
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
        setupOpts = {
          defaults.vimgrep_arguments = [
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

      lsp = {
        enable = true;
        inlayHints.enable = false;
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
        lspconfig.enable = true;
        lspconfig.sources.angularls =
          /*
          lua
          */
          ''
            lspconfig.angularls.setup {
              capabilities = capabilities,
              root_dir = lspconfig.util.root_pattern('angular.json', 'project.json'),
              on_new_config = function(new_config, new_root_dir)
                local local_ngserver = vim.fs.joinpath(new_root_dir, 'node_modules', '@angular', 'language-server', 'bin', 'ngserver')
                local node_modules = vim.fs.joinpath(new_root_dir, 'node_modules')

                if vim.fn.filereadable(local_ngserver) == 1 then
                  new_config.cmd = {
                    local_ngserver,
                    "--stdio",
                    "--tsProbeLocations", node_modules,
                    "--ngProbeLocations", node_modules,
                  }
                  vim.notify("AngularLS: Switched to local project version", vim.log.levels.INFO)
                else
                  vim.notify("AngularLS: Local server not found, using global", vim.log.levels.WARN)
                end
              end,
              on_attach = function (client, bufnr)
                 -- Keep your existing on_attach logic
                 if default_on_attach then default_on_attach(client, bufnr) end
                 client.server_capabilities.renameProvider = false
                 client.server_capabilities.referencesProvider = false
              end
            }
          '';

        servers =
          {
            vtsls = {
              root_dir =
                lib.generators.mkLuaInline
                /*
                lua
                */
                ''
                  function(bufnr, on_dir)
                      -- The project root is where the LSP can be started from
                      -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                      -- We select then from the project root, which is identified by the presence of a package
                      -- manager lock file.
                      local isDenoProject = vim.fs.root(bufnr, {'deno.json', 'deno.jsonc'})
                      if isDenoProject then
                        return nil
                      end
                      local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
                      -- Give the root markers equal priority by wrapping them in a table
                      root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
                        or vim.list_extend(root_markers, { '.git' })
                      -- We fallback to the current working directory if no project root is found
                      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                      on_dir(project_root)
                    end
                '';
              settings = {
                vtsls = {
                  enableMoveToFileCodeAction = true;
                  autoUseWorkspaceTsdk = true;
                  experimental = {
                    maxInlayHintLength = 30;
                    completion = {
                      enableServerSideFuzzyMatch = true;
                    };
                  };
                };
                typescript = {
                  inlayHints = {
                    parameterNames = {enabled = "all";};
                    parameterTypes = {enabled = true;};
                    variableTypes = {enabled = true;};
                    propertyDeclarationTypes = {enabled = true;};
                    functionLikeReturnTypes = {enabled = true;};
                    enumMemberValues = {enabled = true;};
                  };
                  updateImportsOnFileMove = {
                    enabled = "always";
                  };
                };
              };
            };
            html = {
              filetypes = [
                "htmlangular"
                "html"
                "html.handlebars"
              ];
            };
            jsonls = base-json-ls-settings;
            ltex = {
              filetypes = [
                "bib"
                "gitcommit"
                "latex"
                "mail"
                "norg"
                "org"
                "pandoc"
                "rst"
                "tex"
              ];
              settings = {
                ltex = {
                  checkFrequency = "save";
                  language = "en-GB";
                };
              };
            };
          }
          // lib.optionalAttrs myConfig.extras.deno.enable {
            denols = {
              root_markers = [
                "deno.json"
                "deno.jsonc"
              ];
              workspace_required = true;
              single_file_support = false;
              settings = {};
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

      ui = {
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

      assistant = {
        copilot = {
          enable = true;
          cmp.enable = false;
          setupOpts = {
            suggestion = {
              auto_trigger = false;
            };
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
      };

      autocomplete = {
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "default";
            snippets = {preset = "luasnip";};
            fuzzy = {
              implementation = "prefer_rust_with_warning";
              sorts = [
                "exact"
                "score"
                "sort_text"
              ];
            };
            sources = {
              default = [
                "buffer"
                "lsp"
                "snippets"
                "path"
              ];
              per_filetype = {
                sql = ["snippets" "dadbod" "buffer"];
              };
              providers = {
                dadbod = {
                  name = "Dadbod";
                  module = "vim_dadbod_completion.blink";
                };
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
      treesitter.fold = true;
      treesitter.highlight.enable = true;
      treesitter.indent.enable = true;
      treesitter.textobjects = {
        enable = false;
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
