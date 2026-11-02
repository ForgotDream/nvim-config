# 轻量信息学竞赛 Neovim 配置

面向 Linux 下的 C++17 竞赛和 Typst 题解写作，需要 **Neovim 0.11+**。
LSP、诊断、文件浏览使用 Neovim 内置功能；语法高亮由 Treesitter 增强。
补全使用 blink.cmp，片段引擎使用 LuaSnip，括号配对使用 nvim-autopairs，其他插件为 lazy.nvim、Everforest、CompetiTest、nui.nvim 和 Typst Preview。
WhichKey 提供快捷键提示，自动保存使用 Neovim 内置事件实现。
Git 使用 Gitsigns，状态栏使用 Lualine，并与 Everforest 配色保持一致。
主题和补全启动时加载，测试和预览按需加载；默认使用 Everforest 深色版（`background=dark`，`medium` 对比度）。
启用相对行号，当前行显示绝对行号；所有文件默认使用 2 空格缩进，Tab 宽度为 2。
不需要 Nerd Font。

## 启动

此目录放在 `~/.config/nvim` 即可。请先确保这些命令在 `PATH` 中：

| 命令 | 用途 |
| --- | --- |
| `git` | 首次下载插件 |
| `g++` | 编译 C++17，模板使用 GNU 的 `bits/stdc++.h` |
| `clangd` | C++ 补全、诊断、跳转、重命名和格式化 |
| `tinymist` | Typst 语言服务、内置 typstyle 格式化、保存时导出 PDF |
| `curl` | Typst 预览插件下载缺失的辅助程序 |
| `websocat`（可选） | 预览通信；未安装时由预览插件首次启动时下载 |
| `python3`（可选） | 使用 CompetiTest 测试 Python |
| `cc`、`curl`、`tar`、`tree-sitter` | 下载、生成并编译 Treesitter 解析器 |

首次打开 `nvim` 会联网安装插件。等待完成后执行 `:Lazy sync`，重启。
插件版本会记录到自动生成的 `lazy-lock.json`，建议保留并纳入自己的版本管理。
插件安装好之后，C++ 编辑和本地测试可离线使用。
GitHub 不可达时会提示下载失败，内置编辑和已安装的 LSP 仍可使用。

语言服务器需自行安装，可使用系统包管理器，或从
[clangd](https://clangd.llvm.org/installation) 和
[Tinymist Releases](https://github.com/Myriad-Dreamin/tinymist/releases) 获取。
本配置不自动安装语言服务器。安装后重启 Neovim。

## 常用按键

`<leader>` 是空格，组合键在普通模式使用，特别注明的除外。

| 按键 | 功能 |
| --- | --- |
| 普通模式 `;` | 等同于 `:`，进入命令行 |
| 普通模式 `空格 /` / `gcc` | 注释 / 取消注释当前行；支持计数，如 `3gcc` |
| 可视模式 `空格 /` / `gc` | 注释 / 取消注释选中的多行 |
| `空格 w` | 保存 |
| `空格 ya` | 复制当前缓冲区全部文本到系统剪贴板，保留光标和视图位置 |
| `空格 ua` | 开关自动保存（默认开启） |
| `空格 ?` | 查看当前缓冲区可用的快捷键 |
| Git 文件中 `]c` / `[c` | 下一个 / 上一个变更块 |
| Git 文件中 `空格 gp` | 预览变更块 |
| Git 文件中 `空格 gs` / `空格 gS` | 暂存当前变更块 / 当前文件 |
| `空格 e` | 内置文件浏览器，Enter 打开文件，`-` 返回上级目录 |
| `空格 ff` | `:find` 查找文件，Tab 补全路径 |
| `空格 bb` | 列出缓冲区，输入编号或名称切换 |
| 普通模式 `Ctrl-h/j/k/l` | 切换窗口 |
| 插入模式 `Ctrl-h/j/k/l` | 光标左 / 下 / 上 / 右移动 |
| `gd` / `gD` / `gr` | 定义 / 声明 / 引用 |
| `K` | 查看符号文档 |
| 插入模式 `Ctrl-g` 然后 `k` | 函数参数提示 |
| `空格 rn` | 重命名符号 |
| `空格 la` | LSP 代码操作 |
| `空格 f` | 手动格式化；保存不会自动格式化源代码 |
| `空格 d` / `[d` / `]d` | 诊断详情 / 上一条 / 下一条 |
| `空格 q` | 当前缓冲区诊断列表 |
| 插入模式 `Ctrl-Space` | 主动触发 LSP / 片段 / 路径 / 缓冲区补全 |
| 插入模式 `Ctrl-x Ctrl-o` | 终端不支持 Ctrl-Space 时的补全方式 |
| 补全菜单中 `Tab` / `Shift-Tab` | 下一项 / 上一项 |
| 片段内 `Tab` / `Shift-Tab` | 下一个 / 上一个占位符（优先于补全菜单） |
| 补全菜单中 `Ctrl-n` / `Ctrl-p` | 下一项 / 上一项 |
| 补全菜单中 `Enter` / `Ctrl-y` | 确认补全（未选中时确认第一项） |
| 补全菜单中 `Ctrl-e` | 取消补全 |

输入标识符时自动显示补全菜单，Enter 确认候选并展开其中的片段，没有菜单时正常换行。
错误、警告等诊断显示在行尾，同时保留下划线和侧边标记；用 `空格 d` 查看完整信息。
插入模式也会更新诊断，编辑内容以 150 ms 防抖发送给 LSP；显示时间还取决于服务器的分析速度。
默认寄存器与系统剪贴板共用：`y` / `yy` 复制到系统剪贴板，`p` / `P` 从系统剪贴板粘贴，删除操作也会更新剪贴板。
普通模式下按 `空格 ya` 复制当前缓冲区的全部文本（包括未保存的修改）。
Wayland 需要 `wl-copy` / `wl-paste`，X11 可使用 `xclip` 或 `xsel`；可通过 `:checkhealth vim.provider` 检查剪贴板支持。

快速注释复用 Neovim 内置功能，无需额外插件，WhichKey 会显示对应说明。
注释符号根据文件类型选择，例如 C++ / Typst 使用 `//`，Python 使用 `#`。
也可使用原生 `gc{motion}` 操作，例如 `gcip` 注释 / 取消注释整个段落。

## 快捷键提示与自动保存

按空格等快捷键前缀后停顿 300 ms，WhichKey 显示后续按键及中文说明。
`空格 ?` 查看当前缓冲区的快捷键，`:WhichKey` 手动打开提示。
提示使用文字显示按键，不需要图标字体。

自动保存默认开启：输入停顿 1 秒后保存，退出插入模式、离开文件或编辑器失去焦点时立即保存。
只保存已命名、可修改且非只读的普通文件；未命名缓冲区、终端、插件界面和 Git 提交编辑不自动保存。
使用 `空格 ua` 或 `:AutoSaveToggle` 开关；手动 `空格 w` 始终可用。
自动保存保留正常写入事件，因此 Typst 文件也会触发保存时的 PDF 导出。
延迟可在 `lua/config/autosave.lua` 的 `delay` 中调整。

## Git 与状态栏

Gitsigns 在 Git 仓库内显示增删改标记，支持未跟踪文件；相关快捷键只在成功关联的文件中启用。

| 按键 | 功能 |
| --- | --- |
| `]c` / `[c` | 跳到下一个 / 上一个变更块；diff 窗口沿用内置跳转 |
| `空格 gp` | 预览变更块 |
| `空格 gs` | 暂存当前变更块；可视模式下暂存选中的行 |
| `空格 gS` | 暂存当前文件 |
| `空格 gb` | 查看当前行的作者及提交信息 |
| `空格 gd` | 打开与 Git 索引的差异对比；`:diffoff` 退出 diff 模式 |
| `空格 gq` | 将当前文件的变更放入 quickfix 列表 |
| `空格 ug` | 开关行尾提交信息（默认关闭） |
| `ih`（可视 / 操作符等待模式） | 选择一个变更块，例如 `vih` |

Lualine 使用 Everforest 配色与全局状态栏，显示编辑模式、Git 分支和增删改计数、
诊断数量、相对文件路径、LSP 名称、自动保存状态、文件类型、文件进度及行列号。
`AS:on` / `AS:off` 分别表示自动保存开启 / 关闭，诊断计数在插入模式下也会更新。
使用文字和普通分隔符，无需 Nerd Font 或额外图标插件。
配置分别位于 `lua/config/git.lua` 和 `lua/config/statusline.lua`。

## Treesitter

使用 nvim-treesitter 管理解析器，启用基于语法树的高亮。
默认安装 C、C++、Python、Java、Rust、Go、Pascal、Typst，以及 Lua、Vim、帮助文档、查询语言和 Markdown 解析器。
解析器缺失或下载失败时继续使用原有高亮；异步安装完成后自动为已打开的文件启用 Treesitter。
缩进仍由现有配置控制，统一为 2 空格。

Neovim 0.12+ 使用 `main` 分支，需要 `tree-sitter` CLI **0.26.1+**；
Neovim 0.11 使用兼容的 `master` 分支，CLI 使用 **0.25.x**。
两者都需要 C 编译器、`curl`、`tar`，首次下载解析器需要网络。

- `:TSUpdate`：更新已安装的解析器（插件更新后也会自动执行）。
- `:TSInstall cpp typst`：手动安装或补装指定语言。
- `:Inspect` / `:InspectTree`：检查光标处的高亮 / 当前语法树。
- `:checkhealth nvim-treesitter`：检查 Treesitter 环境。

默认解析器列表和高亮行为可在 `lua/config/treesitter.lua` 调整。

## 代码片段与 LSP 联动

补全菜单合并 LSP 建议与 LuaSnip 片段；LSP 返回的函数参数片段也由 LuaSnip 展开。
例如在 C++ 文件输入 `fori`，用 `Ctrl-n` / `Ctrl-p` 选中片段，Enter 确认，
再用 `Tab` 依次填写循环变量、起点和终点，最后进入循环体。重复变量会同步更新。
片段内默认不自动弹出菜单，仍可用 `Ctrl-Space` 手动补全。

| 文件类型 | 片段前缀 |
| --- | --- |
| C++ | `fori` 递增循环、`rfor` 递减循环、`all` 迭代器区间、`vec` 定义 vector、`ll` 类型别名 |
| Typst | `fig` 图片、`eq` 公式、`link` 链接、`code` C++ 代码块 |

自定义片段放在 `lua/snippets/<filetype>.lua`，以 LSP snippet 语法定义：
`${1:默认值}` 是占位符，`$1` 引用同一占位符，`$0` 是最终光标位置。
目前提供的片段无需 `jsregexp` 或额外编译依赖。
blink.cmp 固定使用稳定的 `1.*` 版本和纯 Lua 匹配器，LuaSnip 使用 `v2.*`。
插件下载失败时保留原生 LSP 补全；安装完成并重启后切换到上述统一菜单。

## 括号与引号自动配对

首次进入插入模式时加载 nvim-autopairs，输入 `(`、`[`、`{`、单引号或双引号时自动补齐另一半。
在已有的右括号前再次输入相同的右括号会跳过它；空括号内按 Backspace 成对删除，
空花括号内按 Enter 展开为多行并缩进。`Ctrl-h` 仍用于向左移动光标。
blink.cmp 在确认函数或方法候选时补齐调用括号；LSP / LuaSnip 片段已有的括号会保留。
括号配对独立工作，无需等待 Treesitter 解析器下载。Typst 同样支持普通括号与引号配对。

## C++ 与 CompetiTest

打开下列文件类型时自动加载 CompetiTest，测试快捷键仅绑定在这些语言的缓冲区中。
`空格 cp` 保持全局可用，便于从空白窗口接收新题目。

| 语言 | 常见后缀 | 所需命令 |
| --- | --- | --- |
| C | `.c` | `gcc`（C17） |
| C++ | `.cpp`、`.cc`、`.cxx` | `g++`（C++17） |
| Python | `.py` | `python3` |
| Java | `.java` | `javac`、`java` |
| Rust | `.rs` | `rustc`（edition 2021） |
| Go | `.go` | `go` |
| Pascal | `.pas`、`.pp` | `fpc` |

只需安装自己使用的语言工具链。以上关联用于测试；LSP 仍配置为 C++ 和 Typst。
`.pp` 按竞赛用途固定识别为 Pascal，空文件也可直接使用测试快捷键。
Java 按文件名运行同名主类，例如 `Main.java` 对应 `public class Main`，默认不使用 package。

1. `nvim a.cpp`，按 `空格 ci`（或 `:CppTemplate`）插入竞赛模板，只允许插入空 C++ 文件。
2. 编写程序，从标准输入读取、向标准输出打印。
3. `空格 ca` 添加输入和期望输出。在用例编辑器中，普通模式 `Ctrl-h` / `Ctrl-l` 或插入模式 `Alt-w` 切换输入输出，`Ctrl-s` 保存关闭。
4. `F5` 或 `空格 cr` 保存、编译并测试。在结果窗口按 `d` 查看输出差异，`e` 查看 stderr，`q` 关闭。

| 按键 | CompetiTest 功能 |
| --- | --- |
| `F5` / `空格 cr` | 编译并运行全部用例 |
| `F6` | 使用上次编译的程序运行，用于只修改用例之后 |
| `空格 ca` / `空格 ce` / `空格 cd` | 添加 / 编辑 / 删除用例 |
| `空格 cs` | 重新打开测试结果 |
| `空格 ct` | 接收当前源文件的样例 |
| `空格 cp` | 接收题目、创建目录并填入模板 |

默认编译命令为 `g++ -std=c++17 -O2 -Wall -Wextra a.cpp -o /tmp/a.out`。
编译型语言生成的可执行文件统一存放在 `/tmp/`，Java 类文件输出到 `/tmp`；Python 直接解释运行，避免在源码目录产生二进制杂物。
程序及用例的路径均相对于源文件所在目录，不要求先 `:cd` 到那里。
用例使用单文件打包保存在源文件旁的隐藏目录 `.testcases/`，例如 `.testcases/a.testcases`，同目录下多个源文件按文件名分别保存用例。
默认顺序运行，每个用例限时 2000 ms，比较答案时忽略多余空白。
可在 `lua/config/plugins.lua` 调整时限、编译选项和比较方式；需要严格比较时改成 `"exact"`。
本地计时受机器环境影响，不等同于评测机时间。

在线抓取需要安装浏览器扩展
[Competitive Companion](https://github.com/jmerle/competitive-companion)。
先在 Neovim 按 `空格 ct` 或 `空格 cp`，再在题目页点击扩展按钮。
插件使用默认端口 `27121`。整场比赛可使用 `:CompetiTest receive contest`；
停止接收使用 `:CompetiTest receive stop`。
不安装扩展也可手动添加、运行本地用例。

独立 `.cpp` 文件默认以 C++17 提供 LSP，无需额外项目文件。
有 `compile_commands.json` / `compile_flags.txt` 时，clangd 优先使用项目编译参数。
修改竞赛使用的语言标准时，也请同步调整 `lua/config/lsp.lua` 的 `fallbackFlags`。
如果使用 `freopen`，本地测试时请禁用文件重定向，否则 CompetiTest 无法通过 stdin/stdout 测试。

## Typst

打开 `.typ` 文件即可获得 Treesitter 高亮（解析器可用时）、Tinymist 补全、诊断和跳转；
`空格 f` 使用 Tinymist 内置的 typstyle 格式化，保存时导出 PDF。

| 按键 / 命令 | 功能 |
| --- | --- |
| `空格 tp` | 开关浏览器实时预览 |
| `空格 ts` | 预览滚动到当前光标 |
| `:TypstPreview slide` | 幻灯片预览 |
| `:TypstPreviewStop` | 停止预览 |
| `:TypstPreviewUpdate` | 更新插件下载的预览辅助程序 |

首次预览需要网络下载缺失的 `websocat`，后续可离线使用。
预览复用 `PATH` 中的 `tinymist`，需本机有可用浏览器；通过 SSH 使用时须自行转发预览端口。
当前方案默认预览正在编辑的文件。多文件文档请从主文件启动预览；
可通过环境变量 `TYPST_ROOT` 设置预览项目根目录。
Tinymist 多文件主入口的固定方式参阅其官方文档。

## 文件与检查

- `init.lua`：配置入口。
- `lua/config/options.lua`：缩进、界面等基础选项。
- `lua/config/keymaps.lua`：通用按键与模板命令。
- `lua/config/autosave.lua`：自动保存、延迟与开关。
- `lua/config/git.lua`：Git 变更标记、预览和暂存快捷键。
- `lua/config/statusline.lua`：Everforest 状态栏及其信息组件。
- `lua/config/lsp.lua`：原生 LSP、补全和诊断。
- `lua/config/treesitter.lua`：Treesitter 解析器安装和语法高亮。
- `lua/config/completion.lua`：补全来源、确认按键、占位符跳转与菜单样式。
- `lua/config/plugins.lua`：按需加载的插件和测试参数。
- `lua/snippets/`：C++ 与 Typst 的 LuaSnip 片段。
- `templates/main.cpp`：手动插入和接收题目时共用的模板。

`:checkhealth vim.lsp` 检查语言服务，`:checkhealth lazy` 检查插件管理器。
`:messages` 查看错误，`:lua vim.print(vim.lsp.get_clients({bufnr = 0}))` 查看当前文件连接的服务器。
启动之后若没有补全，先检查 `:set filetype?`，再确认 `:echo executable('clangd')` 或
`:echo executable('tinymist')` 返回 `1`。

参考：[Neovim LSP](https://neovim.io/doc/user/lsp.html)、
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)、
[WhichKey](https://github.com/folke/which-key.nvim)、
[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)、[Lualine](https://github.com/nvim-lualine/lualine.nvim)、
[blink.cmp](https://cmp.saghen.dev/)、[LuaSnip](https://github.com/L3MON4D3/LuaSnip)、
[nvim-autopairs](https://github.com/windwp/nvim-autopairs)、
[Everforest](https://github.com/sainnhe/everforest)、
[CompetiTest](https://github.com/xeluxee/competitest.nvim)、
[Typst Preview](https://github.com/chomosuke/typst-preview.nvim)、
[Tinymist Neovim 支持](https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/README.md)。
