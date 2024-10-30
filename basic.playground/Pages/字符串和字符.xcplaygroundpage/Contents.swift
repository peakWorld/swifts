// 字符串 String类型 | 值类型
// 字符   Character类型

// 多行字符串 <保持格式>
let str = """
The World
    Need Water
"""

// 扩展字符串分隔符<字符串中的特殊字符不生效>
let str1 = "Line 1\nLine 2"   // 跨两行打印字符串
let str2 = #"Line 1\nLine 2"# // 会打印换行转义序列(\n)
print(str1, str2)

// 字符
let chars: [Character] = ["C", "A", "T"]
let str3 = String(chars)

// 字符串插值
let multiplier = 2.5
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"

/* 访问和修改字符串 */
// 字符串索引  访问索引外的字符将触发运行时错误; 无法直接整数索引访问
let greeting = "Guten Tag!"
let start = greeting.startIndex // String.Index => 字符串中首个Character的位置
let end = greeting.endIndex     // 字符串中最后一个字符之后的位置
print(greeting[start])          // 第一个Character的值
print(greeting[greeting.index(before: end)])  // ! => end索引之前
print(greeting[greeting.index(after: start)]) // u => start索引之后
print(greeting[greeting.index(greeting.startIndex, offsetBy: 7)]) // a => start索引后, 第7位
for index in greeting.indices {}    // 访问字符串中各个字符的所有索引

// 插入和移除
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex) // hello!  at插入内容的指定索引处
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex)) // hello there!
print(welcome)

welcome.remove(at: welcome.index(before: welcome.endIndex)) // hello 删除单字符
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range) // 删除多字符

// 子串
let hello = "Hello, world!"
let index = hello.firstIndex(of: ",") ?? hello.endIndex
let beginning = hello[..<index] // "Hello" <复用原始字符串的存储>

// Convert the result to a String for long-term storage.
let newString = String(beginning) // 将子串生成新字符串<独立的存储空间>

// 前后缀
hello.hasPrefix("H")
hello.hasSuffix("!")

