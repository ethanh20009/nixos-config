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
    programs.nvf.settings.vim.keymaps = [
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
        mode = [ "n" "t" ];
        silent = true;
        action = "<cmd>FloatermToggle<CR>";
        desc = "Toggle Floaterm";
      }
      {
        key = "-";
        mode = "n";
        silent = true;
        action = "<cmd>Oil<CR>";
        desc = "Oil";
      }
      {
        key = "<C-d>";
        mode = "n";
        silent = true;
        action = "<C-d>zz";
        desc = "Center after scroll";
      }
      {
        key = "<C-u>";
        mode = "n";
        silent = true;
        action = "<C-u>zz";
        desc = "Center after scroll";
      }
      {
        key = "]d";
        mode = "n";
        silent = true;
        action = "function() vim.diagnostic.jump({count=1, float=true}) end";
        desc = "Next Diagnostic";
        lua = true;
      }
      {
        key = "[d";
        mode = "n";
        silent = true;
        action = "function() vim.diagnostic.jump({count=-1, float=true}) end";
        desc = "Prev Diagnostic";
        lua = true;
      }
      {
        key = "]e";
        mode = "n";
        silent = true;
        action = "function() vim.diagnostic.jump({count=1, float=true, severity=vim.diagnostic.severity.ERROR}) end";
        desc = "Next Error";
        lua = true;
      }
      {
        key = "[e";
        mode = "n";
        silent = true;
        action = "function() vim.diagnostic.jump({count=-1, float=true, severity=vim.diagnostic.severity.ERROR}) end";
        desc = "Prev Error";
        lua = true;
      }
      {
        key = "<leader>gv";
        mode = "n";
        silent = true;
        action = "<cmd>DiffviewOpen<CR>";
        desc = "Diffview";
      }
      {
        key = "<leader>gd";
        mode = "n";
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
        action = "function() Snacks.picker.lsp_references() end";
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
        action = "function() Snacks.bufdelete.other(opts) end";
        lua = true;
        silent = true;
        desc = "Close others";
      }
      {
        key = "<esc>";
        mode = [ "n" "i" "v" ];
        action = "<cmd>noh<CR><esc>";
        desc = "Clear highlight";
      }
      {
        key = "<MiddleMouse>";
        mode = [ "n" "i" "v" ];
        action = "<Nop>";
        desc = "Disable middle click paste";
      }
      {
        key = "<leader>gg";
        mode = "n";
        action = "function() Snacks.lazygit() end";
        lua = true;
        desc = "Lazygit";
      }
      {
        key = "<leader><tab>]";
        mode = "n";
        silent = true;
        action = "<cmd>tabnext<CR>";
        desc = "Next Tab";
      }
      {
        key = "<leader><tab>[";
        mode = "n";
        silent = true;
        action = "<cmd>tabprev<CR>";
        desc = "Prev Tab";
      }
      {
        key = "<leader><tab>d";
        mode = "n";
        silent = true;
        action = "<cmd>tabclose<CR>";
        desc = "Close Tab";
      }
    ];
  };
}
