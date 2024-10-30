// 隐藏有关值类型的实现细节。

/** 不透明类型解决的问题 */
// 不透明类型保留类型标识——编译器可以访问类型信息，但模块的客户端却不能。

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        return "Triangle"
    }
}
let triangle = Triangle(size: 3)

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        return "FlippedShape"
    }
}
let flipped = FlippedShape(shape: triangle) // 暴露了用于创建实例的泛型类型

struct JoinShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return "Join \(top.draw()) \(bottom.draw())"
    }
}
let shape = JoinShape(top: triangle, bottom: flipped)

// 返回不透明类型
func max<T>(_ x: T) -> T where T: Shape { return x } // x的值决定了T的具体类型
max(shape) // 调用函数 可以使用任何符合Shape协议的类型

func makeTrapezoid() -> some Shape { // 返回值符合Shape协议即可,不需指定特定类型;
    return flipped // shape、triangle也可以是返回值
}

// 存在多个返回位置, 那么所有返回值必须有相同的基础类型
//func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//    if (shape is JoinShape) {
//        return shape
//    }
//    return flipped
//}


/** 盒装协议类型 **/

struct VerticalShape: Shape {
    // 盒装协议类型<协议名称前加 any>
    var shapes: [any Shape]
    func draw() -> String {
        return "VerticalShape"
    }
}
let vertical = VerticalShape(shapes: shapes)


/** 差异 */
// 不透明类型指的是一种特定类型，尽管函数的调用者无法看到是哪种类型；
// 装箱协议类型可以指任何符合该协议的类型。

// 盒装协议类型: 数组中的每个元素可以是不同类型, 但每种类型必须符合Shape协议
let shapes: [any Shape] = [flipped, shape, triangle]
// 盒装协议类型: 函数返回值 只能确定符合协议, 却不知具体的类型(无法进行比较)
func test1() -> Shape { return shape }


// 不透明类型: 数组中的元素是一种类型, 且该类型必须符合Shape协议
let shapes2: [some Shape] = [flipped, flipped]
let shapes3: [some Shape] = [triangle, triangle]
//不透明类型 函数返回值 符合协议、且都为同一种类型(可以比较)
func test2() -> some Shape { return shape }

