//
//  ContentView.swift
//  Animations
//
//  Created by windlliu on 2024/10/24.
//

import SwiftUI

struct CornerRoatieModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRoatieModifier(amount: -90, anchor: .topLeading), // 进入｜显示 active -> identity
            identity: CornerRoatieModifier(amount: 0, anchor: .topLeading) // 退出｜隐藏 identity -> active
        )
    }
}

struct ContentView: View {
    
    @State private var showing = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 200, height: 200)
                
                if showing {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 200, height: 200)
                        .transition(.pivot)
                        .zIndex(2)
                }
            }
            
            Text("showing: \(showing ? "True" : "False")" )
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1.0)) {
                showing.toggle()
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/**
 动画基础
 
 Button("Click") {
     animationAmount += 1
 }
 .padding(50)
 .background(.red)
 .foregroundColor(.white)
 .clipShape(Circle())
 .scaleEffect(animationAmount) // 缩放
 .blur(radius: (animationAmount - 1) * 3) // 毛镜
 // 过度动画, 对所有属性变动生效
 // .animation(.default, value: animationAmount)
 // .animation(.linear, value: animationAmount)
 // .animation(.spring(response: 1, dampingFraction: 0.1, blendDuration: 0), value: animationAmount) // 弹簧动画
//            .animation(
//                .easeInOut(duration: 2)
//                    // .delay(1)
//
//                    // .repeatCount(2,  autoreverses: false)
//                    // 每次重复之后自动反转(默认true) autoreverses: true
//                    // .repeatCount(2, autoreverses: true)
//                    // 奇数次的效果, 正常; 偶数次 突然跳跃
//                    // .repeatCount(3, autoreverses: true)
//                    // .repeatForever()
//                ,
//                value: animationAmount
//            )
 */

/**
 方式一  [视图上调用.animation, 必须指定触发动画的属性; 只要属性改变, 就触发动画]
 
 Button("Click") {}
 .padding(50)
 .background(.red)
 .foregroundColor(.white)
 .clipShape(Circle())
 // .overlay 在视图上添加一个覆盖层; 覆盖层的大小和位置会自动适应原始视图的大小和位置。
 .overlay {
     Circle()
         .stroke(.red)
         .scaleEffect(animationAmount) // 1 -> 2
         .opacity(2 - animationAmount) // 1 -> 0
         // value 参数, 告诉SwiftUI在哪个值发生变化时应用动画效果
         // 只有当指定的属性或状态发生变化时，动画才会执行。
         .animation(
             .easeOut(duration: 1)
                 .repeatForever(autoreverses: false),
             value: animationAmount
         )
 }
 .onAppear {
     animationAmount = 2.0
 }
 */

/**
方式二  $value.animation 属性改变时, 主动触发动画(已绑定改属性的视图)
 
 VStack {
     // animationAmount 值改变, 使得button突变
     // Stepper("Scale mount", value: $animationAmount)
     
     // 此处 animation函数使得 animationAmount值改变 时 触发button动画
     Stepper("Scale mount", value: $animationAmount.animation(
         .easeIn(duration: 1)
         .repeatCount(3, autoreverses: true)
     ))
     
     Spacer()
     
     Button("Tap") {
         animationAmount += 1
     }
         .padding(40)
         .background(.red)
         .foregroundColor(.white)
         .clipShape(Circle())
         .scaleEffect(animationAmount)

 }
 */

/**
 方式三 withAnimation [指定属性在某个时间 触发动画]
 
 Button("Click") {
     // 与特定的操作（如按钮点击、手势识别等）关联起来，使得在执行这些操作时触发动画效果
     withAnimation(.spring(response: 1)) {
         // 这些指定的属性或状态发生变化时，动画都会执行。
         animationAmount += 360
         animationAmount2 += 1
     }
 }
 .padding(50)
 .background(.red)
 .foregroundColor(.white)
 .clipShape(Circle())
 .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
 .overlay {
     Circle()
         .stroke(.red)
         .scaleEffect(animationAmount2)
 }
 */


/**
分段动画
 
 VStack {
     Button("click") {
         enabled.toggle()
     }
     .frame(width: 200, height: 200)
     .background(enabled ? .blue : .red)
     .foregroundColor(.white)
     
     // .animation 在 clipShape 之前, 此时动画不会生效
     // 想要动画生效, 必须放在动画生效属性之后
     // .animation(.default, value: enabled)
     // .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
     
     // 分段动画, animation只对之前的生效; 动画同时发生
     // .animation(.easeIn(duration: 1), value: enabled)
     .animation(nil, value: enabled)  // 此动画取消
     .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
     .animation(.spring(response: 1, dampingFraction: 0.3), value: enabled)
 }
 */

/**
 手势动画
 
 LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
     .frame(width: 300, height: 200)
     .clipShape(RoundedRectangle(cornerRadius: 10))
     .offset(dragAmount)
     .gesture(
         DragGesture()
             .onChanged { dragAmount = $0.translation }
             .onEnded { _ in
                 //  dragAmount = .zero
                 
                 // 移动时不会生效, 只在结束时生效
                 withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                     dragAmount = .zero
                 }
             }
     )
     //  在移动的时, 动画也会生效
     // .animation(.spring(response: 0.5, dampingFraction: 0.5), value: dragAmount)
 
 
 struct ContentView: View {
     let letters = Array("Hello SwiftUI")
     
     @State private var enabled = false
     @State private var dragAmount = CGSize.zero
     
     var body: some View {
         
         HStack(spacing: 0) {
             ForEach(0..<letters.count, id: \.self) { num in
                 Text(String(letters[num]))
                     .padding(5)
                     .font(.title)
                     .background(enabled ? .blue : .red)
                     .offset(dragAmount)
                     // 每个方块的延迟动画时间不一样
                     .animation(.linear.delay(Double(num) / 20), value: dragAmount)
             }
         }
         .gesture(
             DragGesture()
                 .onChanged { dragAmount = $0.translation }
                 .onEnded { _ in
                     dragAmount = .zero
                     enabled.toggle()
                 }
         )
     }
 }
 */

/**
 .transition 用于定义视图在进入或离开屏幕时的过渡效果
 
 VStack {
     Button("Click Me") {
         withAnimation {
             showing.toggle()
         }
     }
     
     if showing {
         Rectangle()
             .fill(.red)
             .frame(width: 200, height: 200)
             // .transition(.scale)
             .transition(.asymmetric(insertion: .scale, removal: .opacity))
     }
 }
 */
