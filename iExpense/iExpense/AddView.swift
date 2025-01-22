//
//  addView.swift
//  iExpense
//
//  Created by windlliu on 2024/11/11.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    // 引用类型, 此处修改也会触发ContentView的重渲染
    var expenses: Expenses

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection:  $type) {
                    ForEach(types, id:\.self) {
                        Text($0)
                    }
                }
                
                // format: .currency(code: "CNY")
                // 本地化
                // format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                TextField("Amount", value: $amount, format: .currency(code: "CNY"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
