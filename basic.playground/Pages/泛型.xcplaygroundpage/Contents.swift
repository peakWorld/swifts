// https://chuquan.me/2021/09/25/swift-generic-protocol/

// 非泛型函数<类型 Int改变, 即需要编写不同的函数>
func swap(_ a: inout Int, _ b: inout Int) {
    let tmp = a
    b = a
    a = tmp
}
var someInt = 3
var anotherInt = 107
swap(&someInt, &anotherInt)

// 通用函数<T 类型参数>
func swap2<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
swap(&someInt, &anotherInt)

/** 类型参数<自定义类、结构和枚举> */
// 类型参数指定并命名占位符类型，并紧跟在函数名称之后，位于一对匹配的尖括号之间
// 每当调用函数时，类型参数都会替换为实际类型。

// 定义自己的泛型类型
struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeFirst()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")

/** 扩展泛型类型 */
// 无需提供 类型参数列表 作为扩展定义的一部分。
extension Stack {
    // 原始类型定义中的 类型参数列表<Element> 在扩展主体中可用
    var topItem: Element? {
        // 原始类型参数名称<items> 用于引用原始定义中的类型参数。
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

/** 类型约束 */
// 指定类型参数必须从特定类继承，或者符合特定协议或协议组合。

// 类型约束语法: 通过在类型参数名称后面放置单个类或协议约束来编写类型约束，并用冒号分隔，作为类型参数列表的一部分。
class Person {}
protocol Animal {}

// 类型参数T是Person的子类; 类型参数U符合协议Animal
func some<T: Person, U: Animal>(t: T, u: U) {}

// Equatable协议，要求任何符合的类型实现等于运算符(==)和不等于运算符(!=)来比较该类型的任意两个值
// 所有Swift的标准类型都自动支持Equatable协议。
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        // 并非所有类型都可以与等于运算符(==)进行比较。
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])

/** 关联类型<协议> */
// 关联类型 为用作协议一部分的类型 提供占位符名称。
protocol Container {
    associatedtype Item: Equatable   // 关联类型<符合要求的类型提供, 添加类型约束>
    mutating func append(_ item: Item) // 修改自身<结构体｜枚举>
    var count: Int { get }  // 实例变量
    subscript(i: Int) -> Item { get } // 下标
}

// 泛型符合协议
struct Stack3<Element: Equatable>: Container {
    // original Stack<Element> implementation
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // conformance to the Container protocol
//    typealias Item = Element // 将Item的抽象类型转换为Element的具体类型<可删除>
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

// 在关联类型的约束中使用协议
protocol Suffixable: Container {
    // 两个约束
    // 必须符合Suffixable协议（当前正在定义的协议）,并且它的Item类型必须与Container的Item类型相同。
    associatedtype Suffix: Suffixable where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

// 扩展类型Stack3, 增加对Suffixable协议的一致性
extension Stack3: Suffixable {
    // 无需typealias指定关联类型, suffix返回类型自动推导类型
    func suffix(_ size: Int) -> Stack3 {
        var result = Stack3()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}

/** 通用Where子句 */

// C1必须符合Container协议
// C2还必须符合Container协议
// C1的Item必须与C2的Item相同
// C1的Item必须符合Equatable协议
func allMatch<C1: Container, C2: Container>(_ some: C1, _ another: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
        if some.count != another.count {
            return false
        }
        for i in 0..<some.count {
            if some[i] != another[i] {
                return false
            }
        }
        return true
}

// 扩展 struct - 通用Where子句
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

// 扩展 protocol - 通用Where子句
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

// 关联类型 - 通用Where子句
protocol Container2 {
    associatedtype Item
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

/** 上下文Where子句 */
extension Container {
    // 当Item为Int时, 向Container添加average方法
    func average() -> Double where Item == Int {
        return Double(count)
    }
    // 当Item可相等时, 向Container添加endsWith方法
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}


//extension Container where Item == Int {
//    func average() -> Double {
//        return Double(count)
//    }
//}
//extension Container where Item: Equatable {
//    func endsWith(_ item: Item) -> Bool {
//        return count >= 1 && self[count-1] == item
//    }
//}

// 通用下标
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
            where Indices.Iterator.Element == Int { // 通用where子句要求序列的迭代器必须遍历Int类型的元素
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
