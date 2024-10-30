//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by windlliu on 2024/10/11.
//

import SwiftUI

struct ContentView: View {
    @State private var moves = ["rock", "paper", "scissors"]
    @State private var wins = [1, 2, 0]
    
    @State private var move = Int.random(in: 0...2)
    @State private var machineMoveText = ""
    @State private var personMoveText = ""
    @State private var resultText = ""
    @State private var score = 0
    @State private var count = 0
    @State private var isGameOver = false
    
    let MAX_SIZE = 10
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Slect Move:")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(0..<3) { idx in
                        Button(moves[idx]) {
                            selectMove(idx)
                        }
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Text("Machine: \(machineMoveText)")
                    .font(.body.weight(.heavy))
                    .foregroundColor(.white)
                
                Text("Person: \(personMoveText)")
                    .font(.body.weight(.heavy))
                    .foregroundColor(.white)
                
                Text("Result: \(resultText)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
            }.alert("Game Over", isPresented: $isGameOver) {
                Button("Restart") {
                    restart()
                }
            } message: {
                Text("Total Score: \(score)")
            }
        }
    }
    
    func selectMove(_ moveIdx: Int) {
        machineMoveText = moves[move]
        personMoveText = moves[moveIdx]
        
        if wins[move] == moveIdx {
            score += 1
            resultText = "Person Win"
        } else {
            resultText = "Person Fail"
        }
        
        count += 1
        move = Int.random(in: 0...2)
        
        if (count >= MAX_SIZE) {
            isGameOver = true
        }
    }
    
    func restart() {
        isGameOver = false
        count = 0
        score = 0
        move = Int.random(in: 0...2)
        machineMoveText = ""
        personMoveText = ""
        resultText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/**
 创建视图变量
 
 var motto1: some View {
     Text("Draco")
 }
 
 var motto2 = Text("nun")
 
 // 不推荐
 var spells2: some View {
     Group{
         Text("Draco")
         Text("nun")
     }
 }
 
 // 类似body的使用方式 推荐
 @ViewBuilder var spells: some View {
     Text("Draco")
     Text("nun")
 }
 */

/**
 视图封装
 
 struct CapsuleText: View {
     var text: String
     
     var body: some View {
         Text(text)
             .font(.largeTitle)
             .padding()
             // .foregroundColor(.white) 此处注销, 外部调用才生效
             .background(.blue)
             .clipShape(Capsule())
     }
 }
 
 CapsuleText(text: "First")
     .foregroundColor(.red)
 CapsuleText(text: "Second")
     .foregroundColor(.yellow)
 */

/**
 视图修饰
 
 struct Title: ViewModifier {
     func body(content: Content) -> some View {
         content
             .font(.largeTitle)
             .padding()
             .foregroundColor(.white)
             .background(.blue)
             .clipShape(RoundedRectangle(cornerRadius: 10))
     }
 }

 extension View {
     func titleStyle() -> some View {
         modifier(Title())
     }
 }

 struct Watermark: ViewModifier {
     var text: String
     
     func body(content: Content) -> some View {
         ZStack(alignment: .bottomTrailing) {
             content
             
             Text(text)
                 .font(.caption)
                 .foregroundColor(.white)
                 .padding(5)
                 .background(.black)
         }
     }
 }

 extension View {
     func watermark(with text: String) -> some View {
         modifier(Watermark(text: text))
     }
 }

 
 Text("Hello World!")
     .modifier(Title())
 Text("Second Title")
     .titleStyle()
 
 Color.blue
     .frame(width: 200, height: 200)
     .watermark(with: "windlliu")
 */

/**
 自定义视图
 
 struct GridStack<Content: View>: View {
     let rows: Int
     let columns: Int
     @ViewBuilder let content: (Int, Int) -> Content // 可以返回view数组
     
     var body: some View {
         VStack {
             ForEach(0..<rows, id: \.self) { row in
                 HStack {
                     ForEach(0..<columns, id: \.self) { column in
                         content(row, column)
                     }
                 }
             }
         }
     }
 }
 
 GridStack(rows: 3, columns: 3) { row, column in
     Image(systemName: "\(row * 3 + column).circle")
     Text("R\(row) C\(column)")
 }
 */


/**
 自定义绑定
 
 struct ContentView: View {
     @State private var section = 0
     @State var agreedToTerms = false
     @State var agreedToPrivacyPolicy = false
     @State var agreedToEmails = false
     
     var body: some View {
         // 自定义绑定
         let binding = Binding(get: { section }, set: { section = $0 })
         
         let agreedToAll = Binding(
             get: {
                 agreedToTerms && agreedToPrivacyPolicy && agreedToEmails
             },
             set: {
                 agreedToTerms = $0
                 agreedToPrivacyPolicy = $0
                 agreedToEmails = $0
             }
         )
         
         return VStack(spacing: 15) {
             TextField("Select", value: binding, format: .number)
             
             Toggle("Agree to terms", isOn: $agreedToTerms)
             Toggle("Agree to privacy policy", isOn: $agreedToPrivacyPolicy)
             Toggle("Agree to receive shipping emails", isOn: $agreedToEmails)
             Toggle("Agree to all", isOn: agreedToAll)
         }.padding()
     }
 }
 */
