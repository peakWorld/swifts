//
//  ContentView.swift
//  iExpense
//
//  Created by windlliu on 2024/11/1.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet { // 属性观察器
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // 类初始化赋予值
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decoded
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                // ForEach(expenses.items, id: \.id)
                // items类型遵守协议Identifiable, 省略指定标识符
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)

                            Text(item.type)
                        }

                        Spacer()

                        Text(item.amount, format: .currency(code: "CNY"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}



/**
Codable 简化 JSON 和其他数据格式的编码（encoding）和解码（decoding）过程。
JSONEncoder
 
struct User: Codable {
    let firstName: String
    let lastName: String
}

struct Ch5: View {
    @State private var user = User(firstName: "liu", lastName: "windlliu")
    
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}
*/
 
/**
UserDefaults
@AppStorage
 
struct Ch4: View {
    // 本地存储 小于500Kb
    @State private var count = UserDefaults.standard.integer(forKey: "Tap")
    
    // AppStorage 是 UserDefaults的语法糖
    // 本地存储 键不存在使用默认, 存在则赋值变量 => 保持键和变量同名
    @AppStorage("tapCount") private var tapCount = 0
    
    var body: some View {
        VStack {
            Text("count: \(count)")
            Text("tapCount: \(tapCount)")
            
            Button("Tap") {
                count += 1
                tapCount += 2
                
                UserDefaults.standard.set(count, forKey: "Tap")
            }
        }
    }
}
*/

/**
.onDelete 列表项删除
EditButton  标准的编辑按钮，通常用于表格视图中，允许用户进入编辑模式以添加、删除或重新排序列表项。
 
struct CH3: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeRows(at offset: IndexSet) {
        numbers.remove(atOffsets: offset)
    }
}
*/
 
/**
@Environment 访问当前视图环境
.sheet 开启新视图
 
struct SecondView: View {
    // @Environment一个用于访问当前视图环境的属性包装器
    // 此处允许调用一个dismiss方法来关闭当前视图。
    @Environment(\.dismiss) var dismiss
    
    let name: String
    
    var body: some View {
        Text("Hello, \(name)!")
        
        Button("Close") {
            dismiss()
        }
    }
}

struct CH2: View {
    @State private var  showingSheet = false
    
    var body: some View {
        Button("show sheeting") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "windlliu")
        }
    }
}
*/

/**
 @Observable
 
 // 每次改变属性, 重新创建一个结构体实例 => 触发重新渲染
 struct User {
     var firstName = "U_Bi"
     var lastName = "U_Ba"
 }

 // 都是修改同一个实例中的属性 => 无发重新渲染
 // 引用宏Observable 解决这个问题
 @Observable
 class Person {
     var firstName = "P_Bi"
     var lastName = "P_Ba"
 }

 struct CH1: View {
     // @State 监视的是属性的更改, 而属性其内部的变动不是属性的更改 => 浅比较
     // class是引用类型, 其内属性的改动并不改变自身的内存地址
     
     @State private var user = User()
     @State private var person = Person()
     
     var body: some View {
         VStack {
             Text("Struct: \(user.firstName) \(user.lastName)")
             TextField("firstName", text: $user.firstName)
             TextField("lastName", text: $user.lastName)
             
             Text("Class: \(person.firstName) \(person.lastName)")
             TextField("firstName", text: $person.firstName)
             TextField("lastName", text: $person.lastName)
         }
     }
 }
 */

