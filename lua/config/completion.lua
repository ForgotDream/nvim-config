return {
  snippets = { preset = "luasnip" },
  sources = { default = { "lsp", "snippets", "path", "buffer" } },
  -- 不下载原生二进制，也无需 Rust 工具链。
  fuzzy = { implementation = "lua" },
  -- 自定义映射，保留 Ctrl-h/j/k/l 的光标移动行为。
  keymap = {
    preset = "none",
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-x><C-o>"] = { "show", "fallback" },
    ["<C-y>"] = { "select_and_accept", "fallback" },
    ["<CR>"] = { "select_and_accept", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = false } },
    trigger = { show_in_snippet = false },
    accept = { auto_brackets = { enabled = true } },
    menu = {
      border = "rounded",
      -- 使用文字显示候选类型，不依赖图标字体。
      draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
  },
  cmdline = { enabled = false },
}
