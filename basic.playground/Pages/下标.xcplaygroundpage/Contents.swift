// 类、结构体和枚举可以定义下标
// 下标可以带任意数量的输入参数，并且这些输入参数可以是任意类型。下标还可以返回任何类型的值。
// 下标 不能使用输入输出函数

struct TimeTable {
    let mul: Int
    
    subscript(str: String) -> Int { // 定义下标
        get{ return 1 }
        set{}
    }
    
    subscript(idx: Int) -> Int { // 定义下标<只读>
        return mul * idx
    }
}
let table = TimeTable(mul: 2)
table[6] // 12

// 双参数下标
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = [Double](repeating: 0.0, count: rows * columns)
    }
    
    func indexIsValid(_ row: Int, _ column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row, column), "Index out of range")
            return grid[row * column + column]
        }
        set {
            assert(indexIsValid(row, column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 5, columns: 5)
matrix[1,2] = 3.0

// 类型下标
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}
let mars = Planet[4]
print(mars, mars.rawValue)
