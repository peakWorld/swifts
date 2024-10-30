// Array 数组<有序>, Set 集合<无序唯一>, Dictionary 字典<无序>

// 数组 相同类型的值存储在有序列表中
var arr: [Double] = []
arr.append(1) // 新增元素
var shop = ["Eggs"] // 类型推导

var td = Array(repeating: 0.0, count: 5) // [0.0, 0.0, 0.0, 0.0, 0.0] 特定大小数组，且相同默认值
var td_1 = [Int](repeating: 2, count: 3)
var td2 = arr + td // 符号+ => 兼容类型数组创建新数组

// 访问和修改数组
td[0]       // 根据索引 获取值
td[0] = 1.0 // 根据索引 修改值
td[1...3] = [2.0, 3.0] // 更改范围值
td.insert(4.0, at: td.endIndex - 1) // 指定索引、插入值
td.remove(at: td.endIndex - 1)      // 指定索引、删除值

for item in td { // 迭代数组的值
    print(item)
}
for (index, value) in td.enumerated() { // 迭代数组的索引和值
    print(index, value)
}



// 集合 相同类型的值 没有顺序, 确保唯一性
// 类型必须是可哈希的才能存储在集合中<此类型必须提供一种计算自身哈希值的方法>
// 基本类型<String\Int\Double\Bool>默认是可哈希的
var letters = Set<Character>()
letters.insert("a") // 1个元素
letters = []        // 清空元素

var favory: Set<String> = ["Rock", "Hip"] // 字面数字初始化
var favory2: Set = [2, 3]

favory.insert("Jazz")  // 新增元素
favory.remove("Rock")  // 删除元素, 结果 可选值
favory.contains("HIP") // 是否包含元素
for _ in favory {}  // 迭代集合
favory.sorted()     // 按<排序返回



// 字典
// 将相同类型的键和相同类型的值之间的关联存储在集合中，没有定义的顺序。
var namesOfInt: [Int: String] = [:]
namesOfInt[16] = "sixteem"  // 1个元素
namesOfInt = [:]            // 清空元素
var nam2 = [Int: String]()

var airports = ["X": "TT", "Y": "DD"] // 推导类型
var airports2: [String: String] = ["X": "TT", "Y": "DD"]

airports.updateValue("T1", forKey: "X")
airports["Y"]        // 取值, 可选值
airports["Y"] = "D1" // 赋值
for (code, name) in airports {
    print(code, name)
}
airports.keys
airports.values
let codes = [String](airports.keys) // 数组初始化
