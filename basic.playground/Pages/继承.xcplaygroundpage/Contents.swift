// 一个类可以从另一个类继承方法、属性和其他特征。当一个类继承另一个类时，继承的类称为子类，而它继承的类称为其超类。
// 类可以调用和访问属于其超类的方法、属性和下标，并且可以提供这些方法、属性和下标自己的重写版本，以细化或修改其行为。 
// 类还可以向继承的属性添加属性观察器，以便在属性值更改时收到通知。
// 属性观察器可以添加到任何属性，无论它最初是定义为存储属性还是计算属性。

class Vehice {
    var speed = 0.0
    final var max = 0.0 // 防止被override
    
    var description: String {
        return "traveling at \(speed) miles per hour"
    }
    func makeNoise() {}
}

//子类
class Bicycle: Vehice {
    let hasBasket = false
}

// 重载 override
// 必须始终声明要重写的属性的名称和类型

class Train: Vehice {
    var gear = 1
    
    // 重载方法
    override func makeNoise() {
        print("Choo Choo")
    }
    
    // 重载属性
    override var description: String {
        // super 调用基类属性
        return super.description + " in gear \(gear)"
    }
    
    // 使用属性重写将属性观察器添加到继承的属性<无论该属性最初是如何实现的>
    // 无法将属性观察器添加到继承的常量存储属性或继承的只读计算属性
    // 不能为同一属性同时提供重写setter和重写属性观察器。
    override var speed: Double {
        didSet {
            gear = Int(speed / 10.0) + 1
        }
    }
}

let tr = Train()
print(tr.description)
tr.speed = 10.0
print(tr.description)
