// 函数 执行特定任务的独立代码块；每个函数都有一个类型，由函数的参数类型和返回类型组成。

func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}


/* 参数和返回值 */

// 无返回值函数
func greet1() {}

// 多个返回值<元组>
func minMax(array: [Int]) -> (min: Int, max: Int) {
    return (array[0], array[1])
}
let res = minMax(array: [1, 2, 3])
res.min + res.max

// 隐式返回值: 整个主体是单个表达式；如下两个主体效果一致
func xx1() -> String {
//    "Hello"
    return "Hello"
}

// 参数: 每个参数都有一个参数标签和一个参数名称；默认使用参数名称作为参数标签
// hometown 参数名称<函数主体>，from 参数标签<函数调用>
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))

// 省略参数标签 ｜ 默认参数
func someFunction(_ first: Int, second: Int = 3) {}
someFunction(1, second: 2)
someFunction(1)

// 可变参数: 一个函数可以有多个可变参数。可变参数之后的第一个参数必须具有参数标签。
func arithmeticMean(_ numbers: Double..., size: String..., typex: String) -> Double {
    return numbers[0]
}
arithmeticMean(1, 2, 3, 4, 5, size: "a", "b", typex: "a")

// 输入输出参数 只能是变量
// 函数参数默认为常量。尝试从函数体内更改函数参数的值会导致编译时错误。这意味着您不能错误地更改参数的值。
// 如果希望函数修改参数的值，并且希望这些更改在函数调用结束后保留​​，该参数定义为输入输出参数。

func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)

/* 函数类型 */
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts // 变量定义为函数类型, 并赋值

// 函数作为参数
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

// 函数作为返回值
func chooseStepFunction(backward: Bool) -> (Int, Int) -> Int {
    return mathFunction
}

// 嵌套函数
func test() -> () -> Void {
    var a = 1;
        
    func add() {
        a += 3
        print("a: \(a)")
    }
    
    return add
}

test()()
