local map = vim.keymap.set

map("n", ";", ":", { desc = "进入命令行" })

-- 复用 Neovim 原生注释操作，按当前文件类型选择注释符号。
map("n", "<leader>/", "gcc", { remap = true, desc = "注释 / 取消注释当前行" })
map("x", "<leader>/", "gc", { remap = true, desc = "注释 / 取消注释选中行" })

map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存文件" })
map("n", "<leader>ya", function()
  local view = vim.fn.winsaveview()
  vim.cmd("%yank +")
  vim.fn.winrestview(view)
end, { desc = "复制全部文本到系统剪贴板" })
map("n", "<leader>ua", "<cmd>AutoSaveToggle<cr>", { desc = "开关自动保存" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "取消搜索高亮" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "文件浏览器（内置 netrw）" })
map("n", "<leader>ff", ":find ", { desc = "查找文件（Tab 补全）" })
map("n", "<leader>bb", "<cmd>buffers<cr>:buffer ", { desc = "切换缓冲区" })
map("n", "<C-h>", "<C-w>h", { desc = "左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "右侧窗口" })
map("i", "<C-h>", "<Left>", { desc = "光标左移" })
map("i", "<C-j>", "<Down>", { desc = "光标下移" })
map("i", "<C-k>", "<Up>", { desc = "光标上移" })
map("i", "<C-l>", "<Right>", { desc = "光标右移" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "退出终端输入模式" })

-- 不自动给新文件填模板，避免覆盖已有内容。
vim.api.nvim_create_user_command("CppTemplate", function()
  if vim.bo.filetype ~= "cpp" then
    vim.notify("请在 .cpp 文件中使用 :CppTemplate", vim.log.levels.WARN)
    return
  end
  if vim.api.nvim_buf_line_count(0) ~= 1 or vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] ~= "" then
    vim.notify("模板只能插入空文件。", vim.log.levels.WARN)
    return
  end
  local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "/templates/main.cpp")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { 5, 0 })
end, { desc = "在空 C++ 文件中插入竞赛模板" })
map("n", "<leader>ci", "<cmd>CppTemplate<cr>", { desc = "插入 C++ 模板" })
