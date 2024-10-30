
import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var count = 0
    @State private var clickIndex 
    
    let MAX_SZIE = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        // 后面看完动画 添加的逻辑
                        .opacity(clickIndex < 0 || clickIndex == number ? 1 : 0.25)
                        .rotationEffect(.degrees(clickIndex == -1 ? 0 : clickIndex == number ? 360 : 0))
                        .animation(.default, value: clickIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }.padding()
                
        }.alert(scoreTitle, isPresented: $showingScore) {
            if count >= MAX_SZIE {
                Button("Restart", action: restart)
            } else {
                Button("Continue", action: askQuestion)
            }
            
        } message: {
            Text("Your Score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        clickIndex = number
        
        if correctAnswer == number {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        count += 1
        
        if count >= MAX_SZIE {
            scoreTitle = "Game Over!"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        clickIndex = -1
    }
    
    func restart() {
        count = 0
        score = 0
        scoreTitle = ""
        askQuestion()
        clickIndex = -1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/**
 var body: some View {
     // HStack 横向 / VStack 纵向 / ZStack 空间  类似div
     
     ZStack(alignment: .center) {
         // Color.pink  // 自动填充空余空间
         // Color(red: 1, green: 0.8, blue: 0)
         // Color.pink.frame(width: 200, height: 200) // 设置宽高
         // 深、浅色模式下 自动反转
         // Color.primary.frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200)
         
         VStack(spacing: 0) {
             Color.red
             Color.green
         }
         
         Text("Hello, world!")
             .foregroundColor(.primary)
             .padding(50)
             .background(.ultraThinMaterial)
             
         // Spacer() // 充满空余空间
     }
     .ignoresSafeArea() // 忽略安全区域
 }
 */

/**
 // 线性渐变
 // 按颜色
//        LinearGradient(colors: [.pink, .black], startPoint: .top, endPoint: .bottom)
 // 按区间
//        LinearGradient(stops: [
//            Gradient.Stop(color: .pink, location: 0.35),
//            .init(color: .white, location: 0.55)
//        ], startPoint: .top, endPoint: .bottom)
 
 // 径像渐变
//        RadialGradient(colors: [.pink, .white], center: .center, startRadius: 20, endRadius: 200)
 
//        AngularGradient(colors: [.pink, .white, .red, .black], center: .center)
 
//        Text("Hello World")
//            .frame(maxWidth: .infinity, maxHeight: .infinity) // 拉伸尺寸
//            .foregroundColor(.white)
//            .background(.red.gradient) // 背景颜色渐变
 
 */

/**
 //        Button("delete", action: executeDelete)
         
 //        VStack {
 //            Button("button 1"){}
 //                .buttonStyle(.bordered)
 //
 //            Button("button 2", role: .destructive) {}
 //                .buttonStyle(.borderedProminent)
 //            Button("button 3") {}
 //                .buttonStyle(.borderedProminent)
 //        }
         VStack {
 //            Button("Sign In", systemImage: "pencil.circle.fill", action: executeDelete) 无效
 //
             Button {
                 print("Button was tapped")
             } label: {
     //            Text("tap me").padding().foregroundColor(.white).background(.red)
                 Label("Edit", systemImage: "pencil.circle.fill").padding().foregroundColor(.white).background(.red)
             }
         }
         
         
 //        Image("gagajiao").frame(width: 300, height: 300)
 //        Image(decorative: "gagajiao")
         // sf地址 https://developer.apple.com/sf-symbols/
 //        Image(systemName: "pencil.circle.fill").foregroundColor(.red).font(.largeTitle)
     
 
 */

/**
 struct ContentView: View {
     @State private var showingAlert = false
     
     var body: some View {
         Button("Show alert") {
             showingAlert = true
         }
         .alert("Messgae", isPresented: $showingAlert) {
             Button("Ok") {}
         } message: {
             Text("hahah")
         }
     }
     
     func executeDelete() {
         print("Now Del...")
     }
 }
 */
