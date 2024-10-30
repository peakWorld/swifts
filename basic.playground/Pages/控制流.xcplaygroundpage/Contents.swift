if 1 < 2 {} else {}

//while 1 < 2 {}
//repeat {} while 1 < 2 // 先执行一次

var temperature = 5
//let advice = if temperature <= 0 {
//    "It's cold!"
//} else if temperature >= 30 {
//    "It's warm"
//} else {
////    "not that cold"
//    nil as String?
//}

/** switch */
// 每个case至少包含一个可执行语句
// 一旦第一个匹配的情况完成，整个 switch 语句就完成执行

// 表达式语句
let char: Character = "a"
//let message = switch char {
//case "a", "A":  // 复合匹配, 用逗号分隔值
//    "fisrt alph"
//case "z":
//    "last alph"
//default:
//    "other"
//}
//print(message)

// 区间匹配
var naturalCount = ""
switch temperature {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
default:
    naturalCount = "many"
}

// 元组匹配
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (0, let y):              // 值绑定, 占位常量 y
    print("\(somePoint) is on the y-axis \(y)")
case (let x, 0) where x == 1: // 使用where子句 附加条件; 结果为true, 才执行
    print("\(somePoint) is on the x-axis")
case (let distance,2), (2, let distance):   // 复合匹配
    print("distance \(distance)")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}

// 控制权限
// continue / break / fallthrough / return / throw

// guard
// 把guard近似的看做是Assert<可以优雅的退出而非崩溃>; 必须使用在函数内部、必须带有else语句。
// guard不满足条件要执行的代码放在else的闭包内，满足条件要执行的代码放在guard语句的后面
func register(filed: String?) {
    guard let username = filed, !username.isEmpty else {
        print("不能为空")
        return
    }
}

// defer
// 在程序执行到当前作用域末尾执行; 无论程序如何退出该作用域，defer内部的代码始终运行。
// 一个范围内的多个defer块, 第一块将是最后一个运行。
var score = 3
if score < 10 {
    score += 3;
    defer {
        score -= 5
    }
    print("score inner \(score)")
}
print("score outer \(score)")

// API可用性 #available
func chooseColor() -> String {
    guard #available(macOS 10.12, *) else { // false 执行; 不满足版本才执行else中的代码
        return "gray"
    }
    return "red"
}
