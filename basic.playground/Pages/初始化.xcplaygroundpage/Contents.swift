// 初始化是准备类、结构或枚举的实例以供使用的过程。

/* 设置存储属性的初始值 */
// 类和结构必须在 创建该类或结构的实例时 将其所有存储的属性设置为适当的初始值 -> 存储的属性不能处于不确定状态。
// 在初始化程序中为存储的属性设置初始值，或者通过分配默认属性值作为属性定义的一部分 -> 不调用任何属性观察器。

struct Fash {
    var tmp = 3.2; // 声明属性时 为属性提供默认值
    var tmp2: Double // 初始化程序 为属性提供默认值
    
    var res: String? // 可选属性类型
    
    let text: String // 初始化程序 为常量属性赋值, 一旦赋值就不能再修改
    
    
    init() {
        tmp2 = 3.3;
        text = "hah"
    }
}

/* 默认初始化 */
// 所有存储属性都有 默认值
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()

/** 类继承和初始化 */
// 类的所有存储属性（包括该类从其超类继承的任何属性）都必须在初始化期间分配一个初始值。


