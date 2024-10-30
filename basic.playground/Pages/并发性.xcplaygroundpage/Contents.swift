// 以结构化方式编写异步和并行代码。 Swift 中的并发模型构建在线程之上，但不直接与它们交互。
// 与错误处理相比, 没有安全的方法来包装异步代码，因此可以从同步代码调用它并等待结果。

/** 定义和调用异步函数 */
// 异步函数或异步方法是一种特殊类型的函数或方法，可以在执行中途挂起。
// 调用异步方法时，执行会暂停，直到该方法返回。
  // 异步函数、方法或属性主体中的代码。
  // 结构、类或枚举的static main()方法中的代码<使用@main标记>
  // 非结构化子任务中的代码

func list() async -> Int {2} // async 关键字
func list2() async throws {} // async 在 throws 关键字前

await list()  //  await 暂停点 表示当前代码段可能会在等待异步函数或方法返回时暂停执行。
try await list2()

func listPhotos(_ name: String) async throws -> [String] {
    try await Task.sleep(for: .seconds(2))
    print("after sleep")
    return ["IM"]
}

// 向现有项目添加并发代码时，应自上而下进行。
// 具体来说，首先将最顶层的代码转换为使用并发性，然后开始转换它调用的函数和方法，一次一层地完成项目的架构。
let lists = try? await listPhotos("IM001")
print("main code")

/** 异步序列 */
import Foundation
let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}

/** 并行调用异步函数*/

let photoNames: [String] = []
func downloadPhoto(named photo: String) async -> String {
    return photo
}

// 串行调用
let firstPhoto = await downloadPhoto(named: photoNames[0])
let secondPhoto = await downloadPhoto(named: photoNames[1])
let photos = [firstPhoto, secondPhoto]
print(photos)

// 并行调用 => 非常适合处理不同返回类型的异步任务
// 在定义常量时在let前面编写async, 隐式创建一个子任务<可以看做简化版的任务组>
async let firstPhoto1 = downloadPhoto(named: photoNames[0])
async let secondPhoto1 = downloadPhoto(named: photoNames[1])
// 在每次使用该常量时编写await
let photos1 = await [firstPhoto, secondPhoto]
print(photos1)

/** 任务和任务组 */
// 任务是一个工作单元，可以作为程序的一部分异步运行。
// 给定任务组中的每个任务都有相同的父任务，并且每个任务可以有子任务。
// 当一个子任务因为错误而导致父任务需要抛出错误退出时，这个子任务的兄弟任务会被标记取消，父任务需要等待这些任务完成或者抛出错误（但会忽略这些任务的返回值或者错误），才能真正退出。


// 由于任务和任务组之间存在显式关系，因此这种方法称为结构化并发。
   // 在父任务中，不能忘记等待其子任务完成。
   // 当为子任务设置更高的优先级时，父任务的优先级会自动升级。
   // 当父任务被取消时，其每个子任务也会自动取消。
   // 任务本地值有效且自动地传播到子任务。

func show(_ name: String) {}

// 创建一个任务组 => 适合处理数量不定的相同返回类型的异步任务

// <withThrowingTaskGroup 任务可能引发错误>
// Swift 在条件允许的情况下同时运行尽可能多的这些任务, 无法保证子任务的完成顺序，
await withTaskGroup(of: String.self) { group in
    let photoNames = try! await listPhotos("Summer Vacation")
    // 使用 for-in 循环依次把任务放到任务组，任务被添加时会立刻执行，到达最大并发数量后进行等待；
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }
    
    // 任务组不会返回任何结果
//    for await photo in group {
//        show(photo)
//    }
    
    // 任务组返回结果
    var results: [String] = []
    // 使用 for-await-in 循环依次取回已处理的结果，如果任务还没完成，等待直到完成，或者抛出错误。
    for await photo in group {
        results.append(photo)
    }
    return results
}

// 任务取消
// 每个任务都会在执行过程中的适当位置检查它是否已被取消，并适当地响应取消。
    // 抛出诸如Cancellation Error之类的错误
    // 返回nil或空集合
    // 返回部分完成的工作

await withTaskGroup(of: Optional<String>.self) { group in
    let photoNames = try! await listPhotos("Summer Vacation")
    for name in photoNames {
        // 使用addTaskUnlessCancelled, 避免取消后开始新的工作
        let added = group.addTaskUnlessCancelled {
            guard !Task.isCancelled else { return nil } // isCancelled 检查任务是否已从该任务外部取消
            return await downloadPhoto(named: name)
        }
        guard added else { break }
    }
    
    var results: [String] = []
    for await photo in group {
        if let photo { results.append(photo) }
    }
    return results
}

// 需要立即通知取消的工作
//let task = await Task.withTaskCancellationHandler {
//    print("haha")
//} onCancel: {
//    print("Canceled!")
//}
//
//task.cancel()  // Prints "Canceled!"

/** 非结构化并发*/

// 与任务组的任务不同，非结构化任务没有父任务。
// 可以完全灵活地按照程序需要的任何方式管理非结构化任务。

//let handle = Task {
//    return await listPhotos("Summer Vacation")
//}
//let result = await handle.value


/** Actors  */
// 解决数据竞争的问题

// actor 是一种引用类型，并且不可以被继承。
// actor 内定义的变量和方法都是隔离的，在内部使用可以直接访问，而在外部需要使用 await 进行异步访问。
// 对 actor 的变量访问和方法调用都是消息，在同一时刻只有一条消息可以被处理，多条消息按照顺序依次被处理。当某一条消息需要 await 等待其他异步任务时，消息会被挂起进行等待，actor 得以处理邮箱中的后续消息，表现为 actor 是可重入的。

actor Counter {
    var value = 0

    func increment() -> Int {
        value = value + 1
        return value
    }
}

let counter = Counter()
Task.detached {
    print(await counter.increment())
}
Task.detached {
    print(await counter.increment())
}


// 下载图片文件
// 把下载任务保存起来，先发起第一个异步任务并保存，如果在返回结果之前触发了第二次请求，那么就把上面保存的任务取出，并等待它完成。
typealias Image = String
func downloadImage(from: URL) async throws -> String { "ImageUrl" }

actor ImageDownloader {
    private enum CacheEntry {
        case inProgress(Task<Image, Error>)
        case ready(Image)
    }
    private var cache: [URL: CacheEntry] = [:]

    func image(from url: URL) async throws -> Image? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let handle):
                return try await handle.value
            }
        }

        let handle = Task.init {
            try await downloadImage(from: url)
        }

        cache[url] = .inProgress(handle)

        do {
            let image = try await handle.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }
}

