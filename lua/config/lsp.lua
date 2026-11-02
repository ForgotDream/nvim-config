vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = true,
  virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
  underline = true,
  float = { border = "rounded", source = "if_many" },
})

vim.lsp.config("*", { flags = { debounce_text_changes = 150 } })

-- 在服务器初始化前声明补全能力，使函数参数等 LSP 片段交给 LuaSnip。
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
end

local group = vim.api.nvim_create_augroup("OILsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "跳转定义")
    map("n", "gD", vim.lsp.buf.declaration, "跳转声明")
    map("n", "gr", vim.lsp.buf.references, "查看引用")
    map("n", "K", vim.lsp.buf.hover, "文档提示")
    map("i", "<C-g>k", vim.lsp.buf.signature_help, "函数参数提示")
    map("n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "代码操作")
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "格式化当前文件")

    if not has_blink and client:supports_method("textDocument/completion") then
      -- 插件未安装时保留原生补全；安装后统一由 blink.cmp 管理。
      -- 使用服务器提供的触发字符；普通标识符可按 Ctrl-Space 补全。
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      map("i", "<C-Space>", vim.lsp.completion.get, "触发 LSP 补全")
      -- 表达式映射保留无菜单时正常缩进的行为。
      vim.keymap.set("i", "<Tab>", function()
        return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
      end, { buffer = event.buf, expr = true, desc = "下一补全项 / 缩进" })
      vim.keymap.set("i", "<S-Tab>", function()
        return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-h>"
      end, { buffer = event.buf, expr = true, desc = "上一补全项 / 退格" })
    end
  end,
})

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "查看当前位置诊断" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "上一条诊断" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "下一条诊断" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "诊断列表" })

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--completion-style=detailed", "--header-insertion=never" },
  filetypes = { "cpp" },
  root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
  -- 单文件竞赛无需 compile_commands.json；项目编译数据库优先。
  init_options = { fallbackFlags = { "-std=c++23", "-Wall", "-Wextra" } },
})

vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { "typst.toml", ".git" },
  settings = {
    formatterMode = "typstyle",
    formatterIndentSize = 2,
    exportPdf = "onSave",
  },
})

-- 缺少某个服务器时，其他功能仍然可以使用。
for name, ft in pairs({ clangd = "cpp", tinymist = "typst" }) do
  if vim.fn.executable(name) == 1 then
    vim.lsp.enable(name)
  else
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = ft,
      once = true,
      callback = function()
        vim.schedule(function()
          vim.notify("未找到 " .. name .. "；安装并加入 PATH 后重启 Neovim。", vim.log.levels.WARN)
        end)
      end,
    })
  end
end
