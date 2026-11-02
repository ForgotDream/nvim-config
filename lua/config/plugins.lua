local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  if vim.fn.executable("git") == 0 then
    vim.notify("请先安装 Git，再启动 Neovim 以安装插件。", vim.log.levels.WARN)
    return
  end
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("lazy.nvim 下载失败；检查 GitHub 网络后重启。\n" .. output, vim.log.levels.WARN)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

local competitive_filetypes = { "c", "cpp", "python", "java", "rust", "go", "pascal" }
local function test_key(lhs, command, desc)
  return { lhs, "<cmd>CompetiTest " .. command .. "<cr>", ft = competitive_filetypes, desc = desc }
end

require("lazy").setup({
  {
    "folke/which-key.nvim",
    version = "3.*",
    event = "VeryLazy",
    cmd = "WhichKey",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "查看当前缓冲区快捷键",
      },
    },
    opts = function()
      local keys = {
        Up = "Up", Down = "Down", Left = "Left", Right = "Right",
        C = "Ctrl-", M = "Alt-", D = "Super-", S = "Shift-",
        CR = "Enter", Esc = "Esc", NL = "Enter", BS = "Backspace",
        Space = "Space", Tab = "Tab", ScrollWheelDown = "WheelDown", ScrollWheelUp = "WheelUp",
      }
      for number = 1, 12 do
        keys["F" .. number] = "F" .. number
      end
      return {
        preset = "modern",
        delay = 300,
        icons = { mappings = false, keys = keys },
        triggers = { { "<auto>", mode = "nx" } },
        spec = {
          { "<leader>b", group = "缓冲区" },
          { "<leader>c", group = "竞赛测试" },
          { "<leader>g", group = "Git" },
          { "<leader>l", group = "LSP" },
          { "<leader>r", group = "重构" },
          { "<leader>t", group = "Typst" },
          { "<leader>u", group = "开关" },
          { "<leader>y", group = "复制" },
        },
      }
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.background = "dark"
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
    end,
    config = function()
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Gitsigns",
    opts = require("config.git"),
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = require("config.statusline"),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = vim.fn.has("nvim-0.12") == 1 and "main" or "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    -- 先于 LSP 初始化，确保补全能力与片段引擎均已就绪。
    lazy = false,
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        opts = {
          update_events = "TextChanged,TextChangedI",
          delete_check_events = "TextChanged,InsertLeave",
        },
        config = function(_, opts)
          require("luasnip").config.setup(opts)
          require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
          })
        end,
      },
    },
    opts = require("config.completion"),
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = false,
      map_cr = true,
      map_bs = true,
      map_c_h = false, -- Ctrl-h 保持左移，Backspace 负责成对删除。
    },
  },
  {
    "xeluxee/competitest.nvim",
    ft = competitive_filetypes,
    cmd = "CompetiTest",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      test_key("<F5>", "run", "编译并测试"),
      test_key("<F6>", "run_no_compile", "使用已有程序测试"),
      test_key("<leader>cr", "run", "编译并测试"),
      test_key("<leader>ca", "add_testcase", "添加测试用例"),
      test_key("<leader>ce", "edit_testcase", "编辑测试用例"),
      test_key("<leader>cd", "delete_testcase", "删除测试用例"),
      test_key("<leader>ct", "receive testcases", "接收当前文件的样例"),
      -- 空白窗口也可以接收新题目。
      { "<leader>cp", "<cmd>CompetiTest receive problem<cr>", desc = "接收题目并创建源文件" },
      test_key("<leader>cs", "show_ui", "显示测试结果"),
    },
    opts = {
      save_current_file = true,
      editor_ui = {
        insert_mode_mappings = { switch_window = "<M-w>" },
      },
      compile_command = {
        c = { exec = "gcc", args = { "-std=c17", "-O2", "-Wall", "-Wextra", "$(FNAME)", "-o", "/tmp/$(FNOEXT).out" } },
        cpp = { exec = "g++", args = { "-std=c++17", "-O2", "-Wall", "-Wextra", "$(FNAME)", "-o", "/tmp/$(FNOEXT).out" } },
        java = { exec = "javac", args = { "-encoding", "UTF-8", "-d", "/tmp", "$(FNAME)" } },
        rust = { exec = "rustc", args = { "--edition=2021", "-O", "$(FNAME)", "-o", "/tmp/$(FNOEXT).out" } },
        go = { exec = "go", args = { "build", "-o", "/tmp/$(FNOEXT).out", "$(FNAME)" } },
        pascal = { exec = "fpc", args = { "-O2", "-o/tmp/$(FNOEXT).out", "$(FNAME)" } },
      },
      run_command = {
        c = { exec = "/tmp/$(FNOEXT).out" },
        cpp = { exec = "/tmp/$(FNOEXT).out" },
        python = { exec = "python3", args = { "$(FNAME)" } },
        java = { exec = "java", args = { "-cp", "/tmp", "$(FNOEXT)" } },
        rust = { exec = "/tmp/$(FNOEXT).out" },
        go = { exec = "/tmp/$(FNOEXT).out" },
        pascal = { exec = "/tmp/$(FNOEXT).out" },
      },
      -- 顺序测试，减少多个进程互相争抢 CPU 对计时的影响。
      multiple_testing = 1,
      maximum_time = 2000,
      output_compare_method = "squish",
      testcases_directory = ".testcases",
      testcases_use_single_file = true,
      testcases_single_file_format = "$(FNOEXT).testcases",
      template_file = { cpp = vim.fn.stdpath("config") .. "/templates/main.cpp" },
      received_files_extension = "cpp",
      received_problems_path = "$(CWD)/$(PROBLEM)/main.$(FEXT)",
      received_contests_problems_path = "$(PROBLEM)/main.$(FEXT)",
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    version = "1.*",
    cmd = {
      "TypstPreview", "TypstPreviewStop", "TypstPreviewToggle", "TypstPreviewUpdate",
      "TypstPreviewSyncCursor", "TypstPreviewFollowCursorToggle",
    },
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "开关 Typst 实时预览" },
      { "<leader>ts", "<cmd>TypstPreviewSyncCursor<cr>", ft = "typst", desc = "预览跳到当前光标" },
    },
    opts = function()
      return {
        -- 与 LSP 共用系统 tinymist；仅缺失的 websocat 由插件下载。
        dependencies_bin = {
          tinymist = "tinymist",
          websocat = vim.fn.executable("websocat") == 1 and "websocat" or nil,
        },
      }
    end,
  },
}, {
  defaults = { lazy = true },
  checker = { enabled = false },
  change_detection = { notify = false },
  install = { colorscheme = { "habamax" } },
  ui = { border = "rounded" },
})
