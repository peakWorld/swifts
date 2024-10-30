// 自动引用计数(ARC) 来跟踪和管理应用程序的内存使用情况; 一旦删除了最后一个强引用，值就会被释放，
// 引用计数仅适用于类的实例，结构和枚举是值类型

/** 工作原理 */
// 每次创建类的新实例时，ARC 都会分配一块内存来存储有关该实例的信息。该内存保存有关实例类型的信息，以及与该实例关联的任何存储属性的值。
// 当不再需要某个实例时，ARC 会释放该实例使用的内存，以便该内存可以用于其他目的。
// 如果 ARC 取消分配仍在使用的实例，则将无法再访问该实例的属性或调用该实例的方法。
// 为了确保实例在仍然需要时不会消失，ARC 会跟踪当前引用每个类实例的属性、常量和变量的数量。只要至少一个对该实例的活动引用仍然存在，ARC 就不会释放该实例。
// 为了实现这一点，每当将类实例分配给属性、常量或变量时，该属性、常量或变量都会对该实例进行强引用。


class Person {
    let name: String
    
    init(name: String) {
        self.name = name
        print("\(name) is being inited")
    }
    
    deinit{
        print("\(name) is being deinited")
    }
}

var r1: Person?
var r2: Person?
var r3: Person?

r1 = Person(name: "John") // 变量r1对Person实例的强引用
r2 = r1 // 强引用+1
r3 = r1 // 强引用+1

r1 = nil // 强引用-1
r2 = nil // 强引用-1
r3 = nil // Person实例不存在强引用, ARC施放实例内存

/** 类实例间的强引用循环 */
// 如果两个类实例彼此保持强引用，从而每个实例都使另一个实例保持活动状态。这称为强引用循环。
class Person1 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person1?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person1?
var unit4A: Apartment?

john = Person1(name: "John Appleseed") // 变量john 强引用Person1实例
unit4A = Apartment(unit: "4A") // 变量unit4A 引用Apartment实例

john!.apartment = unit4A // 强引用加1
unit4A!.tenant = john // 强引用加1

// 两个 deinitializer 都没有被调用
john = nil   // 此时Apartment类实例中的属性tenant 还强引用着Person1实例
unit4A = nil

/**  解决类实例之间的强引用循环 */
// 弱引用和无主引用：实例可以相互引用，而无需创建强引用循环。

/** 弱引用 */
// 通过将weak关键字放在属性或变量声明之前来指示弱引用。
// 由于弱引用需要允许其值在运行时更改为nil ，因此它们始终被声明为可选类型的变量，而不是常量。

class Apartment2 {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person? // 弱引用
    deinit { print("Apartment \(unit) is being deinitialized") }
}

/** 无主引用 */
// 通过将unowned关键字放在属性或变量声明之前来指示无主引用。
// 当另一个实例具有相同的生存期或更长的生存期时，将使用无主引用。
// 无主引用应始终具有值。因此，将值标记为无主并不意味着它是可选的，并且ARC永远不会将无主引用的值设置为nil 。

class Customer {
    let name: String
    var card: CreditCard? // 客户可能有也可能没有信用卡
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer // 信用卡将始终与客户相关联
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var jack: Customer?
jack = Customer(name: "Jack Appleseed")
jack!.card = CreditCard(number: 1234_5678_9012_3456, customer: jack!)

jack = nil // jack无强引用, 内存被回收; 则CreditCard实例也无强引用了
