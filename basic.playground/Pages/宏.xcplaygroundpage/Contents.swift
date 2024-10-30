// 宏: 在编译时生成代码
// 1 宏会在编译代码前进行代码转换，即预编译阶段进行处理。
// 2 宏在展开时，永远只会增加代码，不会修改或删除原始的代码。（重点）
// 3 宏的输入和输出都会经过编译器的检查，保证其语法正确，并且如果宏展开后的实现发现异常，也会被处理为编译时异常。

/** 独立宏 */
// 独立宏单独出现，不附加到声明(可以理解为原始代码)中。=> 做简单的代码展开或静态替换
// 要调用独立宏，在其名称前写入数字符号 (#)，并在其名称后的括号中写入宏的所有参数。

func myFunction() {
    // 当编译此代码时，Swift会调用该宏的实现，它将#function替换为当前函数的名称。
    // 当运行此代码并调用myFunction时，它会打印“Currently running myFunction()”。
    print("Currently running \(#function)")
    // 在编译时, 调用Swift标准库中的warning(_:)宏 生成编译时警告
    #warning("Something's wrong")
}

// 独立宏可以产生一个值，就像#function那样; 或者可以在编译时执行一个操作，就像#warning那样。
myFunction()

/** 附加宏 */
// 配合声明一起使用，通常是为了向原代码中增加一些功能。=> 像一种装饰器模式的应用，为原始逻辑进行包装，附加功能。
// 要调用附加的宏，请在其名称前写入at符号 (@)，并在其名称后的括号中写入该宏的所有参数。
@OptionSet
struct SundaeToppings {
    private enum Options: Int {
        case nuts
        case cherry
        case fudge
    }
}

/** 宏声明 */
// 对于宏来说，声明和实现是分开的。
// 宏必须进行声明，声明的主要作用是指定宏的名称、参数以及类型和使用场景。
// 附加宏 名称使用大驼峰式大小写；独立宏 具有小驼峰式名称。

// 例子
//public macro OptionSet<RawType>() =
//        #externalMacro(module: "SwiftMacros", type: "OptionSetMacro")
// 第一行指定宏的名称及其参数 - 名称是Option Set ，并且它不接受任何参数。
// 第二行使用 Swift 标准库中的externalMacro(module: type:)宏来告诉Swift宏的实现所在的位置。
