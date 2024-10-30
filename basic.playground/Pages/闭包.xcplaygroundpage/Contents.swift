// 闭包 可以从定义它们的上下文中捕获和存储对任何常量和变量的引用。

let test = {
//    name in name * 2
    (name: Int) -> Double in Double(name) * 1.0
}
test(3)


let numbers = [3, 5, 7]

numbers.map({ // 匿名闭包
    (number: Int) -> Int in // in 分离 参数和返回值类型的声明 与 闭包函数体
    let result = 3 * number
    return result
})

numbers.map({ number in 3 * number }) // 已知闭包类型 可忽略参数、返回值

let nums = numbers.map{ $0 * 3 } // 使用参数位置来引用参数。闭包作为唯一参数, 忽略圆括号。
print("cal nums: \(nums)")
