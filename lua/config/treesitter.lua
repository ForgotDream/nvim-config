local M = {}

M.parsers = {
  "c", "cpp", "python", "java", "rust", "go", "pascal", "typst",
  "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
}

function M.setup()
  if vim.fn.has("nvim-0.12") == 0 then
    -- 0.11 使用兼容分支的配置接口。
    require("nvim-treesitter.configs").setup({
      ensure_installed = M.parsers,
      sync_install = false,
      auto_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = false },
    })
    return
  end

  local treesitter = require("nvim-treesitter")
  treesitter.setup({})

  local function highlight(buf)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
      return
    end
    local buftype = vim.bo[buf].buftype
    if buftype ~= "" and buftype ~= "help" then
      return
    end
    -- 解析器尚未下载或该语言不受支持时，保留原有语法高亮。
    pcall(vim.treesitter.start, buf)
  end

  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("OITreesitter", { clear = true }),
    callback = function(event)
      highlight(event.buf)
    end,
  })

  -- 异步安装缺失的解析器，完成后为已打开的文件启用高亮。
  treesitter.install(M.parsers):await(function(err)
    if err then
      return
    end
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        highlight(buf)
      end
    end)
  end)
end

return M
