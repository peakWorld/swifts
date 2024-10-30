// 错误处理是响应程序中的错误情况并从中恢复的过程。


// 枚举适用于一组相关错误条件
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

/** 抛出函数 */
// 带有throws标记的函数称为抛出函数。
func canThrowErrors() throws {
    throw VendingMachineError.invalidSelection
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    // vend 方法会传播它抛出的任何错误，所以调用此方法的任何代码都必须处理错误
    // 使用do - catch语句、 try? ，或者try! —— 或者继续传播它们。
    try vendingMachine.vend(itemNamed: snackName)
}

/** Do-Catch */
// 在catch之后编写一个模式来指示该子句可以处理哪些错误。
// 如果catch子句没有模式，则该子句会匹配任何错误并将错误绑定到名为error本地常量。

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}

// 捕获多个相关错误
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError { // 枚举错误
        print("Couldn't buy that from the vending machine.")
    }
}

func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock { // 多种错误
        print("Invalid selection, out of stock, or not enough money.")
    }
}

/** 将错误转换为可选值 */
// 用try?通过将错误转换为可选值来处理错误。
func someThrowingFunction() throws -> Int {
    return 1
}
// 方式一
let x = try? someThrowingFunction()

// 方式二
let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
// 如果someThrowingFunction抛出错误，则x和y的值为nil 。否则， x和y的值就是函数返回的值

// 错误处理简写
func fetchData() -> Int? {
    if let data = try? someThrowingFunction() { return data }
    if let data = try? someThrowingFunction() { return data }
    return nil
}

/** 禁用错误传播 */
// 有时知道抛出函数或方法实际上不会在运行时抛出错误，写try!在表达式之前禁用错误传播。
let photo = try! someThrowingFunction()


/** 使用Result来存储错误 */
// 以便代码在其他地方处理它
func availableRainyWeekendPhotos() -> Result<Int, Error> {
    return Result {
        try someThrowingFunction()
    }
}
let res = availableRainyWeekendPhotos()
