// 枚举为一组相关的值定义了一个共同的类型

// 每个枚举定义一个全新的类型<以大写字母开头, 单数名字>
enum CompassPoint {
    case north  // 使用case关键字 定义一个新的枚举成员值。
    case south  // 不会隐式赋值为 整型值
    case east
    case west
}

print(CompassPoint.north) // north

// 变量dToHead在初始化 推断为类型 CompassPoint
var dToHead = CompassPoint.east
dToHead = .east // 再次赋值时, 可以省略枚举类型名

// 使用switch语句匹配枚举值
// 在判断一个枚举类型的值时，switch 语句必须穷举所有情况。
// 提供一个 default 分支来涵盖所有未明确处理的枚举成员
switch dToHead {
case .north:
    print("north")
//case .south:
//    print("south")
//case .east:
//    print("east")
//case .west:
//    print("west")
default:
    print("other!!!")
}

// 成员遍历
enum Beverage: CaseIterable { // 遵循协议 CaseIterable
    case coffee, tea, juice
}

Beverage.allCases // allCases 包含枚举所有成员的集合

// 关联值: 在创建实例时决定的
enum Barcode {
    case upc(Int, Int, Int, Int) // 枚举成员的upc 具有(Int, Int, Int, Int)类型关联值
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3) // 创建一个基于枚举成员的常量或变量时才设置的值
productBarcode = .qrCode("ABCDEFGHIJKLMNOP") // 枚举成员的关联值可以变化

switch productBarcode { // 关联值可以被提取出来作为 switch 语句的一部分
case let .upc(numberSystem, manufacturer, product, check): // 枚举成员 中所有关联值都背提取为 常量｜变量
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

// 原始值: 在声明的时候就已经决定了
// 可以是字符串、字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

enum Planet: Int {
    case mercury = 1, venus, earth //  隐式原始值 依次递增
}
enum CompassPoint2: String {
    case north, south, east, west // 隐式原始值 为该枚举成员的名称
}

let possiblePlanet = Planet(rawValue: 3) // 创建新的枚举实例。如果存在与原始值相应的枚举成员就返回该枚举成员，否则就返回 nil。
// print("possiblePlanet", possiblePlanet, possiblePlanet?.rawValue) // 类型为 Planet? 值为 Planet.earth

