return {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = ":" },
  },
  attach_to_untracked = true,
  current_line_blame = false,
  preview_config = { border = "rounded" },
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "下一个 Git 变更块")
    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "上一个 Git 变更块")
    map("n", "<leader>gp", gs.preview_hunk, "预览 Git 变更块")
    map("n", "<leader>gs", gs.stage_hunk, "暂存当前变更块")
    map("x", "<leader>gs", function()
      local first, last = vim.fn.line("."), vim.fn.line("v")
      gs.stage_hunk({ math.min(first, last), math.max(first, last) })
    end, "暂存选中的变更行")
    map("n", "<leader>gS", gs.stage_buffer, "暂存当前文件")
    map("n", "<leader>gb", function()
      gs.blame_line({ full = true })
    end, "查看当前行的提交信息")
    map("n", "<leader>gd", gs.diffthis, "与 Git 索引对比")
    map("n", "<leader>gq", gs.setqflist, "当前文件的 Git 变更列表")
    map("n", "<leader>ug", gs.toggle_current_line_blame, "开关 Git 行提交提示")
    map({ "o", "x" }, "ih", gs.select_hunk, "选择 Git 变更块")
  end,
}
