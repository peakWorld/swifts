// 类型安全
// 在编译代码是执行类型检查。如果没有指定值的类型, swift会使用类型推断。


// 基础类型 Int Double Bool String
// 集合类型 Array Set Dictionary

let min = 5 // 常量声明赋值
var max: Int // 变量声明
max = 1 // 变量赋值

var red, green, blue: Double // 定义多个相同类型的相关变量

// 整数
let minV = Int8.min // 有符号整数
let maxV = UInt32.max // 无符号整数

// 在32位平台上, Int == Int32
// 在64位平台上, Int == Int64

// 浮点数
// Double 64位浮点数
// Float 32位浮点数
let mind: Double = 3.14
let minf: Float = 3.14

// 数值类型转换
// 每种数值类型存储不同范围的值, 必须根据具体情况进行数值类型转换
let one: UInt16 = 2
let two = 1
let twoOne = one + UInt16(two)

let three = 3
let four = 0.134
let threeFour = three + Int(four)

// 类型别名
typealias AudioSample = UInt32

// 元组
// 元组中的值可以是任何类型，且彼此间的类型不必相同。
let http404Error = (404, "Not Found")
var (status, messgae) = http404Error  // 元组类型分解
var (status2, _) = http404Error // _ 忽略元组某些元素
print(http404Error.0) // 索引访问元素

let http200Status = (status: 200, messgae: "OK") // 命名元组各个元素
http200Status.status // 元素名称访问元素

// Optional
// 可选值代表两种可能性：要么存在指定类型的值，要么根本不存在值。
let pos = "123"
let posNum = Int(pos)
print(posNum) // Optional(123)

// nil
// 不能将nil与非可选常量(变量)一起使用。
var serverResp: String? = "1"
if (serverResp == nil) {} // 判断值是否为nil, 进行逻辑处理
serverResp?.description   // 通过可选链接?.来处理值
var rsp = serverResp ?? "3" // 提供默认值
serverResp!.description     // 断言有值, 可以触发运行时错误

// 可选绑定

// serverResp 是可选String类型; 如果此处serverResp是一个String值, 则新建一个常量num、且值为serverResp的值
if let num = serverResp {
    print("\(num), \(serverResp)")
} else {
    print("\(serverResp)")
}

// 如果posNum有值, 那么创建新非可选变量posNum；在if语句内引用新的非可选变量，在if语句前或后使用原始可选变量。
if let posNum = posNum {
    print("number is \(posNum)")
}
if let posNum {} // 同名变量简写
if posNum != nil {} // 类似效果

// 断言 和 前提条件
// 断言 仅在调试版本中检查断言。
let age = 1
assert(age > 0, "age is can't less zero") // 结果 为true继续执行; 为false则终止程序、输出提示信息

// 前提条件 在调试和生产版本中都会检查前置条件。
let index = 1
precondition(index > 0, "Index must be greater than zero.") // 结果 为true继续执行; 为false则终止程序。


