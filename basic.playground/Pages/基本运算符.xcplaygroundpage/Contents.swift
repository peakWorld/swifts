var num = 10 / 2.0
var num2 = 10 % 3  // 余数运算符 只适用于整型
print(num, num2)

// 元组比较: 两个元组具有相同的类型和相同的值数量
(1, "zebra") < (2, "apple")   // true because 1 is less than 2; "zebra" and "apple" aren't compared
(3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
(4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
// ("blue", false) < ("purple", true)  // Error because < can't compare Boolean values

// 范围运算符
for _ in 1...5 {} // 全封闭运算符(a...b) 定义从a到b的范围, 并包括a和b；且a的值不得大于b
for _ in 1..<5 {} // 半封闭运算符(a..<b) 定义从a到b的范围, 不包括b；

// 单边范围
let arr = [1, 3, 4, 5]
let arr1 = arr[2...] // [4, 5] 数组从索引2到末尾的元素
let arr2 = arr[...2] // [1, 3, 4] 数组从0到索引2的元素
let arr3 = arr[..<2] // [1, 3] 数组从0到小于索引2的元素
print(arr1, arr2, arr3)

