{
  config,
  pkgs,
  lib,
  myConfig,
  ...
}: let
  cfg = myConfig.nvf;

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
  config = lib.mkIf cfg.enable {
    programs.nvf.settings.vim = {
      luaConfigRC.rust-local-lsp = ''
        if vim.fn.executable("rust-analyzer") == 1 then
          local r = vim.g.rustaceanvim or {}
          r.server = r.server or {}
          r.server.cmd = { "rust-analyzer" }
          vim.g.rustaceanvim = r
        end
      '';

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        lua.enable = true;

        nix.enable = true;
        scala.enable = true;
        markdown = {
          enable = true;
          format = {
            type = ["prettierd"];
          };
        };
        css.enable = true;
        rust = {
          enable = true;
          extensions = {
            crates-nvim.enable = true;
          };
          format.enable = true;
          format.type = ["rustfmt"];
          lsp = {
            enable = true;
            opts = ''
              ['rust-analyzer'] = {
                cargo = {allFeatures = true},
                diagnostics = {
                  disabled = {
                    "proc-macro-disabled",
                  },
                },
                checkOnSave = true,
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = {"async_trait"},
                  },
                },
              },
            '';
          };
        };
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts.formatters_by_ft = {
          python = ["black"];
          htmlangular = ["prettierd"];
          html = ["prettierd"];
          typescript = ["prettierd"];
          javascript = ["prettierd"];
          json = ["prettierd"];
          jsx = ["prettierd"];
          tsx = ["prettierd"];
          markdown = ["prettierd"];
          md = ["prettierd"];
          typescriptreact = ["prettierd"];
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

      lsp = {
        enable = true;
        inlayHints.enable = false;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        presets.tailwindcss-language-server.enable = true;
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
            vim.api.nvim_create_autocmd("FileType", {
              pattern = {"typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular"},
              callback = function(ev)
                local root_dir = vim.fs.root(ev.buf, {"angular.json", "project.json"})
                if not root_dir then return end

                local local_ngserver = vim.fs.joinpath(root_dir, "node_modules", "@angular", "language-server", "bin", "ngserver")
                local node_modules = vim.fs.joinpath(root_dir, "node_modules")

                local cmd
                if vim.fn.filereadable(local_ngserver) == 1 then
                  cmd = {local_ngserver, "--stdio", "--tsProbeLocations", node_modules, "--ngProbeLocations", node_modules}
                else
                  cmd = {"ngserver", "--stdio", "--tsProbeLocations", node_modules, "--ngProbeLocations", node_modules}
                end

                vim.lsp.start({
                  name = "angularls",
                  cmd = cmd,
                  root_dir = root_dir,
                  capabilities = capabilities,
                  on_attach = function(client, bufnr)
                    if default_on_attach then default_on_attach(client, bufnr) end
                    client.server_capabilities.renameProvider = false
                    client.server_capabilities.referencesProvider = false
                  end,
                })
              end,
            })
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
            pyright = {
              filetypes = [
                "python"
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
    };
  };
}
