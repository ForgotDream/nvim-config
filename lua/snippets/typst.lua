local parse = require("luasnip").parser.parse_snippet

return {
  parse({ trig = "fig", name = "带题注的图片" }, [[#figure(
  image("${1:path.png}", width: ${2:80%}),
  caption: [${3:说明}],
) <${4:fig-label}>
$0]]),
  -- LSP snippet 中的字面量美元符号需要转义。
  parse({ trig = "eq", name = "带标签的公式" }, [[\$ ${1:a^2 + b^2 = c^2} \$ <${2:eq-label}>
$0]]),
  parse({ trig = "link", name = "链接" }, '#link("${1:https://example.com}")[${2:文字}]$0'),
  parse({ trig = "code", name = "C++ 代码块" }, [[```cpp
${1:code}
```
$0]]),
}
