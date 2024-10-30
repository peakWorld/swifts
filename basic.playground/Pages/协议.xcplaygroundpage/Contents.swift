// 定义符合类型必须实现的要求。

protocol FirstProtocol {}
protocol AnotherProtocol {}

// 自定义类型声明 采用特定的协议
struct SomeStructure: FirstProtocol, AnotherProtocol {}

protocol SomeProtocol {
    
    /** 属性 */
    // 协议没有指定属性应该是存储属性还是计算属性 - 只指定所需的属性名称和类型，还指定每个属性是否可获取的，或者是可获取且可设置的
    
    // 实例变量属性
    var mustBeSettable: Int { get set }      // 可获取且可设置的
    var doesNotNeedToBeSettable: Int { get } // 可获取的
    
    // 类型属性
    static var someTypeProperty: Int { get set }
    
    /** 方法 */
    // 没有大括号和主体, 不能为方法参数指定默认值。
    
    // 类型方法
    static func someTypeMethod(person: Int)
    
    // 实例方法
    func random() -> Double
    
    // mutating方法 允许修改它所属的实例以及该实例的任何属性
    // 实现协议时, 类无需编写mutating关键字; mutating关键字仅由结构和枚举使用
    mutating func toggle()
    
    /** 初始化 */
    init(param: Int)
}

struct SomeClass: SomeProtocol {
    
    var mustBeSettable: Int
    
    var doesNotNeedToBeSettable: Int {
        return 2
    }
    
    static var someTypeProperty: Int = 1
    
    static func someTypeMethod(person: Int) {}
    
    func random() -> Double { return 2.1 }
    
    mutating func toggle() {
        self.mustBeSettable = 3
    }
        
    init(param: Int) {
        mustBeSettable = 1
    }
    
    // 类中实现协议 必须有required
    // required init(param: Int) {}
}

// 初始化
protocol SomeProtocol2 {
    init()
}
class SomeSuperClass {
    init() {
    }
}
class SomeSubClass: SomeSuperClass, SomeProtocol2 {
    // 既有重载, 还要匹配协议
    required override init() {
    }
}

/** 作为类型 */
// 协议本身实际上并不实现任何功能。
    // 使用协议作为泛型约束的信息。
    // 不透明类型和盒装协议类型

/** 通过扩展添加协议一致性 */
// 即使无权访问现有类型的源代码，也可以扩展现有类型 以采用并符合新协议。
struct Dice {
    let sides: Int
}
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

// 如果类型已经符合协议的所有要求，但尚未声明它采用该协议，则可以使其采用具有空扩展名的协议
// 类型不会仅仅满足其要求就自动采用协议，必须始终明确声明采用该协议。
struct Hamster {
    var name: String
    var textualDescription: String { // 已经符合协议的所有要求, 但尚未声明采用该协议
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {} // 采用具有空扩展名的协议


/** 采用综合实现的协议 */
// Equatable 、 Hashable和Comparable

/** 协议类型集合 */
// 协议可以用作存储在集合（例如数组或字典）中的类型
let things: [TextRepresentable] = [Hamster(name: "1b"), Dice(sides: 3)]


/** 协议继承 */
// 协议可以继承一个或多个其他协议，并且可以在其继承的要求之上添加更多要求。
protocol PrettyTextRepresentable: TextRepresentable, SomeProtocol2 {
    var prettyTextualDescription: String { get }
}


/** 仅类协议 */
// AnyObject协议 将协议采用限制为类类型
protocol Some1: AnyObject {}
class Some2: Some1 {} // 协议Some1只能类 采用

/** 协议组成 */
// 要求一个类型同时符合多个协议。 SomeProtocol & AnotherProtocol
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) { // 协议组合, celebrator参数必须符合两种协议
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

/** 检查协议一致性*/
// 如果实例符合协议，则is运算符返回true ；如果不符合协议，则返回false 。
// as?向下转型运算符的版本返回协议类型的可选值，如果实例不符合该协议，则该值为nil 。
// as!向下转型运算符的版本会强制向下转型为协议类型，如果向下转型不成功，则会触发运行时错误。

/** 协议扩展*/
// 扩展协议以向一致类型提供方法、初始化器、下标和计算属性实现。
// 允许在协议本身上定义行为，而不是在每种类型的单独一致性或全局函数中定义行为。
// 协议扩展可以添加实现，但不能使协议扩展或继承另一个协议。
protocol RandomNumberGenerator {}
extension RandomNumberGenerator { // 协议扩展
    func randomBool() -> Bool { // 默认实现
        return true
    }
}

struct Random: RandomNumberGenerator {}
let radom = Random()
radom.randomBool()

// 覆盖默认实现
struct Random2: RandomNumberGenerator {
    func randomBool() -> Bool {
        return false
    }
}

// 向协议扩展添加约束
extension Collection where Element: Equatable { // 通用where子句在要扩展的协议名称之后编写约束
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
print(equalNumbers.allEqual()) // Prints "true"
print(differentNumbers.allEqual()) // Prints "false"


/** 委托 */
// 委托是一种设计模式，使类或结构能够将其部分职责移交给（或委托）给另一种类型的实例。
//class DiceGame {
//    let sides: Int
//    weak var delegate: Delegate? // 弱引用 weak
//    init(sides: Int) {
//        self.sides = sides
//    }
//    func roll() -> Int {
//        return Int(Double(sides)) + 1
//    }
//    func play(rounds: Int) {
//        delegate?.gameDidStart(self)
//        for round in 1...rounds {
//            let player1 = roll()
//            let player2 = roll()
//            if player1 == player2 {
//                delegate?.game(self, didEndRound: round, winner: nil)
//            } else if player1 > player2 {
//                delegate?.game(self, didEndRound: round, winner: 1)
//            } else {
//                delegate?.game(self, didEndRound: round, winner: 2)
//            }
//        }
//        delegate?.gameDidEnd(self)
//    }
//    protocol Delegate: AnyObject {
//        func gameDidStart(_ game: DiceGame)
//        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
//        func gameDidEnd(_ game: DiceGame)
//    }
//}
//
//class DiceGameTracker: DiceGame.Delegate {
//    func gameDidStart(_ game2: DiceGame) {}
//    func game(_ game: DiceGame, didEndRound round: Int, winner: Int?) {}
//    func gameDidEnd(_ game: DiceGame) {}
//}

