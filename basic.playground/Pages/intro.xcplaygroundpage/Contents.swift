import UIKit

let array1 = ["a"]
let map1 = ["a": 1]
let array2: [String] = [] // 空数组
let map2: [String: Float] = [:] // 空字典

var opstr: String? = "hello" // 可选变量
opstr = nil

var opstr2: String = "hello" // 变量类型必须保持一致
//opstr2 = nil


var total = 0
for i in 0..<5 {
    total += i
}
print(total)


// 函数
func greet(persion: String, day: String) -> String {
    return "Hello \(persion), today is \(day)"
}

greet(persion:"Bob", day:"Tuesday") // 参数名 作为参数标签

func greet2(_ persion: String, on day: String) -> String { // 不使用参数标签 | 自定义参数标签
    return "Hello \(persion), today is \(day)"
}
greet2("Bob", on:"Tuesday")

func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool { // 函数作为参数
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}

func lessThanTen(num: Int) -> Bool {
    return num < 10
}
hasAnyMatches(list: [20, 19, 7, 12], condition: lessThanTen)

// 闭包   使用{}创建一个匿名闭包
let numbers = [3, 5, 7]

numbers.map({ // 匿名闭包
    (number: Int) -> Int in // in 分离 参数和返回值类型的声明 与 闭包函数体
    let result = 3 * number
    return result
})

numbers.map({ number in 3 * number }) // 已知闭包类型 可忽略参数、返回值

let nums = numbers.map{ $0 * 3 } // 使用参数位置来引用参数。闭包作为唯一参数, 忽略圆括号。
print("cal nums: \(nums)")

// 对象和类
class Shape {
    var  numberOfSides: Int = 0
    var  name: String
    
    // 构造函数 初始化类实例
    init(name: String) {
        self.name = name;
    }
    
    // 析构函数
    deinit {}
    
    func simpleDes() -> String {
        return "A shpae with \(numberOfSides) sides."
    }
}

var shape = Shape(name: "Named")

class Square: Shape { // 类继承
    var sideLength: Double // 存储属性
    
    var perimeter: Double { // 计算属性
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0 // 默认入惨；在set之后圆括号中显示设置一个名字
        }
    }
    
    init(_ sideLength: Double, name: String) {
        self.sideLength = sideLength;
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDes() -> String { // 方法重载
        return "A \(numberOfSides)"
    }
}
let square = Square(2.1, name: "square");
square.perimeter = 9.0;


// 枚举和结构体
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace // 枚举成员
let aceRawValue = ace.rawValue // 枚举成员 原始值
let aceDescription = ace.simpleDescription() // 枚举方法, 枚举成员可调用
print(ace, aceRawValue, aceDescription)

// 并发性
func fetchUserID(from server: String) async -> Int { // async 标记异步运行的函数
    sleep(2)
    if server == "primary" {
        return 97
    }
    return 501
}

func fetchUsername(from server: String) async -> String {
    let userID = await fetchUserID(from: server) // await 对异步函数的调用
    if userID == 501 {
        return "John"
    }
    return "Guest"
}
func connectUser(to server: String) async {
    async let userID = fetchUserID(from: server) // 使用 async let 调用异步函数
    async let username = fetchUsername(from: server) // 与其他异步代码 -> 并行运行
    let greeting = await "Hello \(username), user ID \(userID)" // 当使用异步函数返回的值时，使用await 。
    print(greeting)
}

Task { // Task 从同步代码中调用异步函数; 无需等待返回值
    await connectUser(to: "primary")
}

// 使用任务组 构建并发代码
let userIDs = await withTaskGroup(of: Int.self) {group in
    for server in ["primary", "secondary", "development"] {
        group.addTask {
            return await fetchUserID(from: server)
        }
    }
    var results: [Int] = []
    for await result in group {
        results.append(result)
    }
    return results
}
print(userIDs)

// 协议和扩展

// 错误处理
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

func send(job: Int, toPrinter printerName: String) throws -> String { // throws 标记可引发错误的函数
    if printerName == "Never" {
        throw PrinterError.noToner // throw 引发错误
    }
    return "job"
}

do { // do-catch 处理错误
    let res = try send(job: 1040,toPrinter: "bi") // try 标记可引发错误的代码
    print(res)
} catch PrinterError.noToner { // 处理特定错误
    print("test1")
} catch let printError as PrinterError {
    print("test2 \(printError)")
} catch {
    print(error)
}

// try? 处理错误
// 将结果转为可选。 函数抛错，则丢弃特定错误，结果为nil; 否则结果为可选值, 包含函数返回结果。
let res = try? send(job: 1884, toPrinter: "jj")

var isOpen = false
func fridge(_ food: String) -> Bool {
    isOpen = true
    
    // defer 代码块
    // 该代码块 在函数中所有其他代码之后、函数返回之前执行
    // 无论函数是否抛错, 此代码块都会执行
    defer {
        isOpen = false
    }
    
    return false
}

// 泛型
func makeArray<Item>(repeating item: Item, nums: Int) -> [Item] {
    var res: [Item] = []
    for _ in 0..<nums {
        res.append(item)
    }
    return res
}
makeArray(repeating: "K", nums: 3)

enum OpVal<T> {
    case none
    case some(T)
}
var pos: OpVal<Int> = .none
pos = .some(100)
