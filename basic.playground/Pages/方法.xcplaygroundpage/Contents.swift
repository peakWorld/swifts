// 类、结构和枚举都可以定义实例方法，这些方法封装了处理给定类型实例的特定任务和功能。
// 类、结构和枚举还可以定义与类型本身关联的类型方法。

/** 实例方法 */
// 实例方法可以隐式访问该类型的所有其他实例方法和属性。实例方法只能在其所属类型的特定实例上调用。
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        self.count = 0 // 每个实例有一个名为self的隐式属性<与实例本身相同>
    }
}

// 从实例方法内修改值类型
// 默认情况下结构体和枚举<值类型>，无法从实例方法内修改值类型的属性。

// 通过mutating关键字，允许该方法修改它所属的实例以及该实例的任何属性。
// 该方法在方法内部改变其属性，并且当方法结束时，它所做的任何更改都会写回原始结构。该方法还可以为其隐式self属性分配一个全新的实例，并且该新实例将在该方法结束时替换现有实例。
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0) // 实际上修改了调用它的点，而不是返回新点。

// 在mutating方法中重新赋值 self
struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point2(x: x + deltaX, y: y + deltaY) // 创建一个新结构
    }
}
enum TriStateSwitch {
    case off, low, high
    
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next() // .high
ovenLight.next() // .off

/** 类型方法 */
struct Person {
    static func human() {} // 类型方法
}
class Person2 {
    static func human() {}
    class func woman()  {} // 类可以使用class关键字来代替，以允许子类覆盖超类的该方法的实现。
}
