return {
  options = {
    theme = "everforest",
    icons_enabled = false,
    globalstatus = true,
    component_separators = "|",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
        source = function()
          local status = vim.b.gitsigns_status_dict
          if status then
            return { added = status.added, modified = status.changed, removed = status.removed }
          end
        end,
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        update_in_insert = true,
      },
    },
    lualine_c = { { "filename", path = 1, symbols = { modified = " [+]", readonly = " [RO]" } } },
    lualine_x = {
      function()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          names[#names + 1] = client.name
        end
        return table.concat(names, ", ")
      end,
      function()
        return require("config.autosave").enabled and "AS:on" or "AS:off"
      end,
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "quickfix" },
}
