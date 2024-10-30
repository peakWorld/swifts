//
//  ContentView.swift
//  WordScramble
//
//  Created by windlliu on 2024/10/17.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    
    @State private var errotTitle = ""
    @State private var errorMessage = ""
    @State private var alertShow = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Enter your world", text: $newWord)
                            .textInputAutocapitalization(.never) // 输入时文本自动大写
                        
                        Spacer()
                        
                        Text("Socre: \(score)")
                    }
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit { // 键盘按下 return/确定 按钮时触发; 作用于包围块内的 输入框
                addNewWord()
            }
            .onAppear(perform: startGame)
            .alert(errotTitle, isPresented: $alertShow) {} message: {
                Text(errorMessage)
            }
            .toolbar() {
                Button("Start", action: startGame)
//                Text("Start")
//                    .onTapGesture {
//                        startGame()
//                    }
            }
            
        }
    }
    
    // 单词确认, 验证逻辑
    func addNewWord() {
        // lowercased 小写
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        // 已填写
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        // 匹配词根
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        // 真实单词
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        // 添加动画
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += 1
        
        newWord = ""
    }
   
    // 读取文本 选择词根
    func startGame() {
        score = 0
        
        //  Bundle.main 来获取当前应用程序的主Bundle
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // print("startWordsUrl", startWordsUrl)
            if let startWords = try? String(contentsOf: startWordsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        // 一个宏，用于在代码中显式地终止程序的执行，并输出一条错误信息。
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal (word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible (word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            // firstIndex 用于查找字符串中第一个匹配指定条件的字符的位置
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal (word: String) -> Bool {
        let checker = UITextChecker() // 单词拼写验证
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func check (word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        
        if (word == rootWord) {
            return false
        }
        
        return true
    }
    
    func wordError(title: String, message: String) {
        errotTitle = title
        errorMessage = message
        alertShow = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/**
 VStack(spacing: 0) {
     List {
         Text("static Row")
         ForEach(0..<3, id: \.self) {
             Text("Row \($0)")
         }
     }
     .listStyle(.grouped)
     
     
     List(people, id: \.self) {
         Text("people \($0)")
     }
 }
 */

/**
 let input = "A B C"
 let letters = input.components(separatedBy: " ")
 
 let input2 = """
 A
 B
 C
 """
 let letters2 = input.components(separatedBy: "\n")
 
 
 let letter = letters.randomElement()
 let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
 
 */

/**
 let word = "swift gaod"
 // print("count => \(word.count), utf8 count => \(word.utf8.count)")
 
 // 检查文本中的拼写错误，并提供可能的正确拼写建议（仅限英语）
 let checker = UITextChecker()
 let range = NSRange(location: 0, length: word.utf16.count)
 // wrap 是否循环检查
 let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
 
 // 没有拼写错误
 // misspelledRange => {6, 4} 错误开始位置(从0开始), 字节长度
 let allGood = misspelledRange.location == NSNotFound
 print("allGood", misspelledRange, allGood)
 */
