{
  myConfig,
  lib,
  config,
  pkgs,
  ...
}: let
in {
  options = {
  };
  config = lib.mkMerge [
    # Settings for SERVER mode
    (lib.mkIf (myConfig.nvf.companion == "gemini") {
      programs.nvf.settings.vim = {
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
      };
    })

    # Settings for CLIENT mode
    (lib.mkIf (myConfig.nvf.companion == "claude") {
      programs.nvf.settings.vim = {
        lazy.plugins = {
          "claudecode.nvim" = {
            package = pkgs.vimPlugins.claudecode-nvim;
            setupModule = "claudecode";
            lazy = true;
            event = [
              {
                event = "User";
                pattern = "LazyFile";
              }
            ];
            setupOpts = {
              terminal_cmd = "/run/current-system/sw/bin/claude";
              diff_opts = {
                open_in_new_tab = true;
                keep_terminal_focus = false;
              };
            };
            keys = [
              {
                key = "<leader>at";
                mode = "n";
                action = "<cmd>ClaudeCode<cr>";
              }
              {
                key = "<leader>aa";
                mode = "v";
                action = "<cmd>ClaudeCodeFocus<cr>";
              }
              {
                key = "<leader>aa";
                mode = "n";
                action = "<cmd>ClaudeCodeAdd %<cr>";
              }
              {
                key = "<leader>aca";
                mode = "n";
                action = "<cmd>ClaudeCodeDiffAccept<cr>";
              }
              {
                key = "<leader>acd";
                mode = "n";
                action = "<cmd>ClaudeCodeDiffDeny<cr>";
              }
              {
                key = "<C-h>";
                mode = "t";
                action = "<C-\\><C-n><C-w>h<Esc>";
              }
            ];
          };
        };
      };
    })
  ];
}
