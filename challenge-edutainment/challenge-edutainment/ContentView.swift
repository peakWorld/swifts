//
//  ContentView.swift
//  challenge-edutainment
//
//  Created by windlliu on 2024/10/29.
//

import SwiftUI

struct ContentView: View {
    @State private var size = 3
    @State private var correctAnswer = 0
    @State private var answer = 0
    @State private var showInput = false
    @State private var score = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Section(
                    header: HStack {
                        Text("Change Size")
                            .font(.largeTitle)
                        Spacer()
                        Text("Score(\(score))")
                    }
                ) {
                    Picker("Change Size", selection: $size) {
                        ForEach(2..<10, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 30)
                }
                .foregroundColor(.white)
                .onChange(of: size) { _ in
                    reset()
                }
                
 
                Section("Content") {
                    ForEach(1..<size+1, id: \.self) { row in
                        HStack {
                            ForEach(1..<size+1, id: \.self) { col in
                                
                                if (row >= col) {
                                    // 调整色相计算方式
                                    let hue = Double(row * size + col) / Double(size * size)
                                    let currentIdx = row * col
//                                    let fontSize = 11
                              
                                    Text("\(row) * \(col)")
                                        .font(.system(size: 11))
                                        .foregroundColor(
                                            Color(hue: hue, saturation: 1, brightness: 1)
                                        )
                                        .padding(4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(
                                                    correctAnswer == currentIdx ? Color.red: Color.blue, lineWidth: 1
                                                )
                                                .animation(.default, value: correctAnswer)
                                        )
                                        .onTapGesture {
                                            correctAnswer = currentIdx
                                            showInput = true
                                        }
                                }
                            }
                        }.padding(3)
                    }
                }
                .foregroundColor(.white)
                .font(.subheadline)
                
                if showInput {
                    Section(header: Text("Enter Answer").padding(.top, 20)) {
                        TextField("Enter Answer", value: $answer, format: .number)
                            .keyboardType(.default)
                    }
                    .foregroundColor(.white)
                    .onSubmit {
                        if answer == correctAnswer {
                            score += 1
                        }
                        reset()
                    }
                }
               
                
                Spacer()
            }
            .padding(5)
        }
    }
    
    func reset() {
        correctAnswer = 0
        answer = 0
        showInput = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
