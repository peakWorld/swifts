// 定义自定义运算符、执行按位运算并使用构建器语法。

// Swift 中的算术运算符默认不会溢出。溢出行为被捕获并报告为错误。
// 要选择溢出行为，使用Swift默认情况下会溢出的第二组算术运算符，这些溢出运算符均以与号(&)开头。

//  Swift 可以自由定义中缀、前缀、后缀和赋值运算符，以及自定义优先级和关联性值。

/** 按位运算符  */

// 按位非运算符
let initialBits: UInt8 = 0b00001111
let invertedBits = ~initialBits  // equals 11110000

// 按位与运算符
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8  = 0b00111111
let middleFourBits = firstSixBits & lastSixBits  // equals 00111100

// 按位或运算符
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedbits = someBits | moreBits  // equals 11111110

// 按位异或运算符 => 当输入位不同时，该数字的位设置为1 ；当输入位相同时，该数字的位设置为0 ：
let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits  // equals 00010001

/** 按位左移和右移运算符 */
// 按位左移运算符(<<) 和按位右移运算符(>>) ，将数字中的所有位向左或向右移动一定数量的位置。
// 按位左移和右移具有将整数乘以或除以二的效果。将整数的位向左移动一个位置使其值加倍，而向右移动一个位置则使其值减半。

// 无符号整数的转换行为
// 1. 现有位将按请求的位数向左或向右移动。
// 2. 任何超出整数存储范围的位都将被丢弃。
// 3. 将原始位左移或右移后留下的空格中插入零。
let shiftBits: UInt8 = 4   // 00000100 in binary
shiftBits << 1             // 00001000
shiftBits >> 2             // 00000001

// 有符号整数的转变行为
// 有符号整数 其第一位（称为符号位）来指示整数是正数还是负数。符号位为0表示正，符号位为1表示负。
// 其余位（称为值位）存储实际值。

/** 溢出运算符 */
// 如果将数字插入到无法保存该值的整数常量或变量中，则默认情况下Swift会报告错误，而不是允许创建无效值。
var potentialOverflow = Int16.max
//potentialOverflow += 1 // this causes an error

// 溢出条件来截断可用位数时
// 溢出加法(&+)  溢出减法(&-)  溢出乘法(&*)
var unsignedOverflow = UInt8.max
unsignedOverflow = unsignedOverflow &+ 1

/** 优先级和关联性 */
// 运算符优先级 赋予某些运算符比其他运算符更高的优先级。
// 运算符关联性 定义了相同优先级的运算符如何分组在一起 - 从左侧分组，或从右侧分组。

/** 重载现有运算符 */
// 中缀运算符 类和结构可以提供它们自己的现有运算符的实现。
struct Vector2D {
    var x = 0.0, y = 0.0;
}
extension Vector2D {
    // 重载加法(+)运算符; 由于加法不是基本基本行为, 因此在扩展中定义、而不是在主结构中定义
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector

// 前缀和后缀运算符
    // 类和结构还可以提供标准一元运算符的实现。一元运算符对单个目标进行操作。
    // 如果它们位于目标之前（例如-a ），则它们是前缀；如果它们位于目标之后（例如b! ），则它们是后缀运算符。
extension Vector2D {
    // prefix 前缀 | postfix 后缀
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}
var negative = -vector

// 复合赋值运算符
    // 复合赋值运算符 将赋值(=) 与另一个操作结合起来。
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}
negative += anotherVector

// 等价运算符
    // 默认情况下，自定义类和结构没有等价运算符的实现，即等于运算符 (==) 和不等于运算符 (!=)。
    // 通常实现==运算符，添加对 Swift 标准库的Equatable协议的一致性。
extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
       return (left.x == right.x) && (left.y == right.y)
    }
}
if negative == anotherVector {
    print("These two vectors are equivalent.")
}

/** 自定义运算符 */
// 新的运算符使用operator关键字在全局级别声明，并用prefix 、 infix或postfix修饰符进行标记
prefix operator +++  // 定义了一个名为+++的新前缀运算符

extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}

// 自定义中缀运算符的优先级
    // 每个自定义中缀运算符都属于一个优先级组。
infix operator +-: AdditionPrecedence // 定义了一个名为+-新中缀运算符，它属于优先级组AdditionPrecedence
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

/** 结果构建者 */
// 添加用于以自然的声明性方式创建嵌套数据的语法。
// 可以包含普通的Swift语法（例如if和for ）来处理条件数据或重复的数据。
protocol Drawable {
    func draw() -> String
}
struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}
struct Text: Drawable {
    var content: String
    init(_ content: String) { self.content = content }
    func draw() -> String { return content }
}
struct Space: Drawable {
    func draw() -> String { return " " }
}
struct Stars: Drawable {
    var length: Int
    func draw() -> String { return String(repeating: "*", count: length) }
}
struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}

// 通过调用它们的初始值设定项来使用这些类型进行绘图
let name: String? = "Ravi Patel"
let manualDrawing = Line(elements: [
     Stars(length: 3),
     Text("Hello"),
     Space(),
     AllCaps(content: Text((name ?? "World") + "!")),
     Stars(length: 2),
])
print(manualDrawing.draw()) // "***Hello RAVI PATEL!**"

