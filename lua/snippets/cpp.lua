local parse = require("luasnip").parser.parse_snippet

return {
  parse({ trig = "fori", name = "下标递增循环" }, [[for (int ${1:i} = ${2:0}; $1 < ${3:n}; ++$1) {
  $0
}]]),
  parse({ trig = "rfor", name = "下标递减循环" }, [[for (int ${1:i} = ${2:n} - 1; $1 >= 0; --$1) {
  $0
}]]),
  parse({ trig = "all", name = "容器迭代器区间" }, "${1:a}.begin(), $1.end()$0"),
  parse({ trig = "vec", name = "定义 vector" }, "vector<${1:int}> ${2:a}(${3:n});$0"),
  parse({ trig = "ll", name = "long long 别名" }, "using ll = long long;$0"),
}
