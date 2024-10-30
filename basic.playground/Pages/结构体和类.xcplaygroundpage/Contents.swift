// 结构体是 值类型，类是 引用类型。

// 通用
// 定义属性来存储值
// 定义提供功能的方法
// 定义下标以使用下标语法提供对其值的访问
// 定义初始值设定项以设置其初始状态
// 进行扩展以将其功能扩展到默认实现之外
// 遵守协议以提供某种类型的标准功能

// 类特有
// 继承使一个类能够继承另一个类的特性。
// 类型转换使的能够在运行时检查和解释类实例的类型。
// 析构器使类的实例能够释放它已分配的任何资源。
// 引用计数允许对一个类实例进行多个引用。

// 每定义一个新的结构体或类时，就定义了一个新的类型。
struct SomeStruct {}
class someClass {}

// 定义
struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var rate = 0.0
    var name: String?
}

/** 结构体 */
// 初始化 新结构实例的成员属性
let vga = Resolution(width: 640, height: 480)

// 基本类型-整数、浮点数、布尔值、字符串、数组、字典 都是值类型
// 结构体、枚举 是值类型
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide") // 2048
print("hd is still \(hd.width) pixels wide") // 1920

