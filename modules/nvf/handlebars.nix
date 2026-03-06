{...}: {
  programs.nvf.settings.vim.luaConfigRC.handlebarsIndent =
    /*
    lua
    */
    ''
      -- Handlebars indent function (converted from VimL)
      local function get_handlebars_indent()
        local sw = vim.bo.shiftwidth
        if sw == 0 then
          sw = vim.bo.tabstop
        end

        local lnum = vim.v.lnum

        -- Get base indent from subtype indentexpr
        local ind = 0
        local subtype_expr = vim.b.handlebars_subtype_indentexpr
        if subtype_expr and subtype_expr ~= "" then
          -- Execute the subtype's indentexpr
          ind = vim.fn.eval(subtype_expr) or 0
        end

        -- Workaround for Andy Wokula's HTML indent
        if subtype_expr and subtype_expr:match("^HtmlIndent%(") then
          local b_indent = vim.b.indent
          if b_indent and type(b_indent) == "table" and b_indent.lnum then
            vim.b.indent.lnum = -1
          end
        end

        local prev_lnum = vim.fn.prevnonblank(lnum - 1)
        local prevLine = vim.fn.getline(prev_lnum)
        local currentLine = vim.fn.getline(lnum)

        -- indent after block {{#block or {{^block
        if prevLine:match("%s*{{[#^].*%s*") then
          ind = ind + sw
        end

        -- but not if the block ends on the same line
        if prevLine:match("%s*{{#([%w%-]+)[%s}].*{{/%1") then
          ind = ind - sw
        end

        -- unindent after block close {{/block}}
        if currentLine:match("^%s*{{/%S*}}%s*$") then
          ind = ind - sw
        end

        -- indent after component block {{word
        if prevLine:match("%s*{{%w") then
          ind = ind + sw
        end

        -- but not if the component block ends on the same line
        if prevLine:match("%s*{{%w.+}}") then
          ind = ind - sw
        end

        -- unindent }} lines, and following lines if not inside a block expression
        local savedPos = vim.fn.getpos(".")
        local is_closing_line = currentLine:match("^%s*}}%s*$")
        local prev_has_closing = not currentLine:match("^%s*{{/") and prevLine:match("^%s*[^{} \t]+}}%s*$")

        if is_closing_line or prev_has_closing then
          local closingLnum = vim.fn.search("}}\\s*$", "Wbc", prev_lnum)
          local result = vim.fn.searchpairpos("{{", "", "}}", "Wb")
          local openingLnum, col = result[1], result[2]

          if openingLnum > 0 and closingLnum > 0 then
            local opening_text = vim.fn.getline(openingLnum):sub(col, col + 2)
            if not opening_text:match("{{[#^]") then
              ind = ind - sw
            end
          else
            vim.fn.setpos(".", savedPos)
          end
        end

        -- unindent {{else}}
        if currentLine:match("^%s*{{else.*}}%s*$") then
          ind = ind - sw
        end

        -- indent again after {{else}}
        if prevLine:match("^%s*{{else.*}}%s*$") then
          ind = ind + sw
        end

        return ind
      end

      -- Make the function global so it can be called from indentexpr
      _G.GetHandlebarsIndent = get_handlebars_indent

      -- Autocmd to set indentexpr for html.handlebars files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "html.handlebars",
        callback = function()
          vim.bo.indentexpr = "v:lua.GetHandlebarsIndent()"
          -- Store the HTML indent expression as the subtype
          vim.b.handlebars_subtype_indentexpr = "HtmlIndent()"
        end,
      })
    '';
}
