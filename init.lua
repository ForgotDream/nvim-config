-- 轻量竞赛配置：Neovim 0.11+，以原生功能为主。
if vim.fn.has("nvim-0.11") == 0 then
  vim.api.nvim_echo({ { "这份配置需要 Neovim 0.11 或更新版本。", "ErrorMsg" } }, true, {})
  return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autosave").setup()
require("config.plugins")
require("config.lsp")
