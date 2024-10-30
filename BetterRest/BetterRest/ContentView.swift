//
//  ContentView.swift
//  BetterRest
//
//  Created by windlliu on 2024/10/12.
//

// 自定义弹窗
// https://medium.com/@teresabagala/custom-alert-in-swiftui-348917dba90c

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeUp
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
   
    // 默认时间
    static var defaultWakeUp: Date {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        var component = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    // cup单词的复数形式 跟随coffeeAmount数量改变
                    // Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) { idx in
                            Text("\(idx)")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
                    .font(.system(size: 50)) // 自定义字体样式, 不会生效
                    .foregroundColor(.red)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // 睡觉时长
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // 起床时间 - 睡觉时长 = 睡觉时间
            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/**
 struct ContentView: View {
     @State private var sleepAmount = 8.0
     @State private var wakeUp = Date.now
     
     var body: some View {
         VStack{
             Stepper("\(sleepAmount.formatted()) Hours", value: $sleepAmount, in: 4...12, step: 0.5)
             
             DatePicker("selected", selection: $wakeUp, displayedComponents: .date)
                 .labelsHidden() // 隐藏文本
             DatePicker("selected", selection: $wakeUp, in: Date.now...)
             
             
             Text(Date.now, format: .dateTime.day().month().year())
         }
     }
     
     func calacTime() {
         let tomorrow = Date.now.addingTimeInterval(86400) // 一天的秒数
         let range = Date.now...tomorrow // 时间范围
         
         // 设置某个日期
         var components = DateComponents()
         components.year = 2014
         components.month = 10
         components.day = 14
         components.hour = 12
         components.minute = 33
         let date = Calendar.current.date(from: components) ?? .now
         print("date \(String(describing: date))")
         
         // 获取某个日期的时间
         let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
         let hour = components.hour ?? 0
         let minute = components.minute ?? 0
         print("hour \(hour), minute \(minute)")
     }
 }
 
 */
