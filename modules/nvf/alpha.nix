{...}: {
  programs.nvf.settings.vim.pluginRC.alpha = ''
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
      {type = "padding", val = 3},
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
}
