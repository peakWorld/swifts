// 向现有类型<类、结构、枚举或协议>添加功能。
    // 添加计算实例属性和计算类型属性
    // 定义实例方法和类型方法
    // 提供新的初始化器
    // 定义下标
    // 定义和使用新的嵌套类型
    // 使现有类型符合协议
// 注: 扩展可以向类型添加新功能，但不能覆盖现有功能。

struct SomeType {}

extension SomeType {} // extension关键字 扩展声明
extension SomeType: Sendable {} // 添加协议一致性

// 扩展现有类型添加新功能，则新功能将在该类型的所有现有实例上可用，即使它们是在定义扩展之前创建的。

/** 计算属性 */
// 可以添加新的计算属性，但不能添加存储的属性，也不能向现有属性添加属性观察器。
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
}
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")

/** 初始化器 */
// 向现有类型添加新的初始值设定项。
    // 扩展其他类型以接受自定义类型作为初始值设定项参数，
    // 提供未包含在该类型的原始实现中的其他初始化选项。

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect() // 所有属性提供了默认值
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
    size: Size(width: 5.0, height: 5.0))

extension Rect { // 扩展新的初始化
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size) // 调用自动初始化
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
    size: Size(width: 3.0, height: 3.0))

/** 方法 */
// 向现有类型添加新的实例方法和类型方法。
extension Int {
    // 新的实例方法
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    // 扩展的实例方法 修改实例本身
    mutating func square() {
        self = self * self
    }
        
    // 新的下标
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

var some = 3
some.repetitions {
    print("Hello!")
}
some.square()
print("some", some)

/** 嵌套类型 */
extension Int {
    enum Kind { // 嵌套类型
        case negative, zero, positive
    }
    var kind: Kind { // 计算属性
        switch self { // self 实例自身
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

print("kind", some.kind)
