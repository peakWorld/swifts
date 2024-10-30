// 类型转换 确定值的运行时类型并为其提供更具体的类型信息, 通过is和as运算符实现。

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

// library数组的类型是通过使用数组文字的内容初始化来推断的。
// Swift的类型检查器能够推断出Movie和Song有一个共同的超类Media Item，因此它推断出library数组的[Media Item]类型
let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

/** 检查类型  */
// 使用类型检查运算符(is) 检查实例是否属于某个子类类型。
// 如果实例属于该子类类型，则类型检查运算符返回true ，否则返回false 。
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

/** 向下转换 */
// 条件形式<as?> 返回尝试向下转换为的类型的可选值。
    // 将始终返回一个可选值，如果无法进行向下转换，则该值将为nil 。
// 强制形式<as!> 尝试将结果向下转换并强制展开结果作为单个复合操作。
    // 尝试向下转换为不正确的类类型，这种形式的运算符将触发运行时错误

for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

/** Any 和 AnyObject 的类型转换 */
// Any 可以表示任何类型的实例，包括函数类型。
// AnyObject 可以表示任何类类型的实例。
var things: [Any] = []

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

// 已知类型为Any或AnyObject的常量或变量的特定类型，可以在switch语句的情况下使用is或as模式。
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
