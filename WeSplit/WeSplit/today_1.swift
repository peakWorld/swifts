//
//  ContentView.swift
//  WeSplit
//
//  Created by windlliu on 2024/9/12.
//

import SwiftUI

struct ContentView2: View {
  let students = ["Harry", "Hermione", "Ron"]
  @State private var selected = "Harry"
  @State private var tapCount = 0
  @State private var name = ""

  var body: some View {
    //        VStack {
    //            Image(systemName: "globe")
    //                .imageScale(.large)
    //                .foregroundColor(.accentColor)
    //            Text("Hello, world!")
    //        }
    //        .padding()

    //        NavigationStack {
    //            Form { // 表单
    //                Section { // 分块
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                }
    //
    //                Section {
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                }
    //
    //                Section {
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                    Text("Hello ")
    //                }
    //            }
    //            .navigationTitle("SwiftUI")
    //            .navigationBarTitleDisplayMode(.inline)
    //        }

    //        Button("tap Count: \(tapCount)") {
    //            tapCount += 1
    //        }

    //        Form {
    //            TextField("Enter", text: $name)
    //            Text("Hello, \(name)")
    //        }

    NavigationStack {
      Form {
        Picker("Selected Your Name", selection: $selected) {
          ForEach(students, id: \.self) {
            Text($0).fontWeight(.heavy)
          }
        }
      }.navigationTitle("Selected")
    }
  }
}
