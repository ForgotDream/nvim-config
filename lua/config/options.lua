local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 5
opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.showmode = false
opt.laststatus = 3
opt.statusline = "%f %h%m%r%=%y  %l:%c  %p%%"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.shortmess:append("c")
opt.wildignore:append({ "*.o", "*.out", "*.exe", "*.pdf", "*.testcases" })

-- 默认的复制、删除和粘贴都使用系统剪贴板（+ 寄存器）。
opt.clipboard = "unnamedplus"
vim.cmd.colorscheme("habamax")

-- 竞赛中的 .pp 文件按 Free Pascal 源码识别，包括尚未输入内容的新文件。
vim.filetype.add({ extension = { pp = "pascal" } })

local group = vim.api.nvim_create_augroup("OIEditing", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
