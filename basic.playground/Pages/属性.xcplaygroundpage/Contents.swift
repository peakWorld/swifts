
/** 存储属性 */

// 作为特定类或结构的实例的一部分存储的常量或变量。
struct Range {
    var first: Int  // 变量存储属性
    let length: Int // 常量存储属性
    var fr: [String] = []
    let sr: [String] = []
}
var range = Range(first: 0, length: 3) // <结构体>实例赋值变量
range.first = 1
//range.length = 3 // error
range.fr.append("a")
//range.sr.append("a") // error

let range2 = Range(first: 0, length: 3) // <结构体>实例赋值常量
//range2.first = 1     // error
//range2.fr.append("a")// error
//range.sr.append("a") // error

// 由于结构体是值类型, 当实例被标记为常量时、它所有属性也被标记为常量。

/** 惰性存储属性 */
// 惰性存储属性<lazy 修饰符> 直到第一次使用时才计算其初始值的属性。
class DataImporter{
    let filename = "xx.txt"
}
class DataManager{
    lazy var importer = DataImporter()
    var data: [String] = []
}
let manager = DataManager()
manager.importer.filename // 首次调用才初始化

/**  计算属性 */
// getter来检索/setter来设置 属性和值
struct Point {
    var x = 0.0, y = 0.0;
}
struct Size {
    var width = 0.0, height = 0.0;
}
struct Rect {
    var origin = Point()
    var size = Size()
    
    var center: Point { // 计算属性
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    
    var square: Double { // 只读计算属性
        return size.width * size.height
    }
}

/** 属性观察器 */

// 属性观察器 每次设置属性值时都会调用属性观察器，即使新值与属性的当前值相同

// 添加属性观察者位置
    // 存储属性
    // 计算属性 使用属性的 setter 来观察并响应值更改
    // 继承的存储属性|计算属性<在子类中重写该属性来添加属性观察器>

// 定义观察者
    // willSet 在存储值之前被调用
    // didSet 在新值存储后立即调用

struct Step {
    var totalSteps: Int = 1 {
        willSet(newTotalSteps) { // 将新的属性值作为常量参数传递
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet { // 传递一个包含旧属性值的常量参数oldValue
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
var step = Step()
step.totalSteps = 3;

/** 属性包装器 */

// 属性包装器 在属性存储和属性定义<不包含初始化外的赋值>之间添加了一层隔离。
// 定义属性包装器 创建一个结构体、枚举或类, 且定义有wrappedValue属性。

@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct Rectangle {
    @TwelveOrLess var height: Int;
    @TwelveOrLess var width: Int;
}

var rect2 = Rectangle()
rect2.height = 0;
rect2.height = 24; // 实际值为12

// 设置包装属性的初始值<和赋值不一样>
@propertyWrapper
struct SmallNumber {
    private var max: Int
    private var number: Int
    
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, max) }
    }
    
    init() {
        max = 12
        number = 0
    }
    
    init(wrappedValue: Int) { // 参数名称必须为 wrappedValue
        max = 12
        number = min(wrappedValue, max)
    }
    
    init(wrappedValue: Int, max: Int) {
        self.max = max // 参数和私有变量同名
        number = min(wrappedValue, max)
    }
}

struct ZeroRect {
// init()初始化
//    @SmallNumber var height: Int
//    @SmallNumber var width: Int
    
// 转化为 init(wrappedValue:)初始化
//    @SmallNumber var height: Int = 1
//    @SmallNumber var width: Int = 1
    
// init(wrappedValue:, max:)初始化
//    @SmallNumber(wrappedValue: 2, max: 5) var height: Int
//    @SmallNumber(wrappedValue: 3, max: 4) var width: Int
    
    // init(wrappedValue:)
    @SmallNumber var height: Int = 1
    // init(wrappedValue:, max:)
    @SmallNumber(max: 9) var width: Int = 2
}

// 从属性包装器投影值

@propertyWrapper
struct SmallNumber2 {
    private var number: Int
    private(set) var isSet: Bool
    
    var wrappedValue: Int {
        get { return number }
        set {
            number = newValue
            isSet = true
        }
    }
    
    init() {
        number = 0
        isSet = false
    }
}

struct Some {
    @SmallNumber2 var num: Int
}
var some = Some()
some.num = 2;
//print("some \(some.num) \(some.$num)")


/** 全局变量和局部变量 */
// 全局变量是在任何函数、方法、闭包或类型上下文之外定义的变量。
// 局部变量是在函数、方法或闭包上下文中定义的变量。

var k1: Int = 1 // 全局存储属性

var key1: Int { // 全局计算属性
    get { return k1 }
    set { k1 = 10 }
}
var key2: Int = 1 { // 全局属性观察器
    willSet {
        print("key2 willset \(newValue)")
    }
    didSet {
        print("key2 willset \(oldValue)")
    }
}
func key3() {
    @SmallNumber var num1: Int = 1 // 局部属性观察器, 无全局属性观察器
}

/** 类型属性<静态变量> */
// 属于该类型本身的属性，而不是属于该类型的任何一个实例的属性; 无论创建多少个该类型的实例，这些属性都只会有一份副本。
// 对特定类型的所有实例通用的值非常有用。
struct Some2 {
    static var gp = "static value" // 类型属性
}
Some2.gp = "haha"
