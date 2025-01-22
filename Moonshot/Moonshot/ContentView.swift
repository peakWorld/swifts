//
//  ContentView.swift
//  Moonshot
//
//  Created by windlliu on 2025/1/8.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        LazyVStack {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
        }
    }
}

#Preview {
    ContentView()
}


/**
 资源位
 Image("Example")
 Image(.example)
 
 切割图片内容 -> 部分内容
 Image(.example)
     .frame(width: 300, height: 300)
     .clipped()
 
 缩放图片内容 -> 完整内容
 Image(.example)
     .resizable()
     .frame(width: 300, height: 300)
 
 图片区域X轴 为 屏幕X轴的 60&
 Image(.example)
     .resizable()
     .scaledToFit()
     .containerRelativeFrame(.horizontal) {size, axis in
         size * 0.6
     }
 */

/**
 视图帧
 NavigationStack {
     NavigationLink("Tap Me") {
         Text("Smile")
     }
     .navigationTitle("Title")
 }
 */

/**
 Json Decoder
 
 struct User: Codable {
     let name: String
 }
 
 Button("Click") {
     let input = """
         {
             "name": "Taylor Swift",
         }
         """
     let data = Data(input.utf8)
     let decoder = JSONDecoder()
     
     if let user = try? decoder.decode(User.self, from: data) {
         print(user.name)
     }
 }
 */

/**
 网格布局
 let layout = [
     GridItem(.adaptive(minimum: 80, maximum: 120)) // 每个格子自适应
 ]
 
 列
 ScrollView {
     LazyVGrid(columns: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }
 
 行
 ScrollView(.horizontal) {
     LazyHGrid(rows: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }
 */
