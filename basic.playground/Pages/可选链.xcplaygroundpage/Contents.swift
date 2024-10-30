// 可选链接是一个查询和调用当前可能为nil可选属性、方法和下标的过程。
// 如果可选项包含值，则属性、方法或下标调用成功；如果可选值为nil ，则属性、方法或下标调用将返回nil 。


// 可选值后面放置问号 ( ? ) 来指定可选链; 可选值后面放置感叹号 ( ! ) 以强制展开其值。
// 区别在于，当可选值为nil时，可选链接会正常失败，而当可选值为nil时，强制展开会触发运行时错误。

struct John {
    var res: Int?
}
var john: John? = John() // jojn是可选类型

if john?.res != nil {
    print("possible")
} else {
    print("not possible")
}

// 任何通过可选链设置属性的尝试都会返回Void? ，这使的能够与nil进行比较以查看该属性是否已成功设置
if (john?.res = 3) != nil {
    print("possible")
}

