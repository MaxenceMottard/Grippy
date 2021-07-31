//
//  LaunchScreen.swift
//  LaunchScreen
//
//  Created by Maxence Mottard on 31/07/2021.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var titleFontSize = 64.0
    @State private var typingAnimationIsEnded = false
    @State private var compressionViewIsPresented = false

    var animation: Animation {
        Animation.easeInOut(duration: 0.8)
    }
    
    var body: some View {
        ZStack {
            lauchScreenView
            
            if compressionViewIsPresented {
                CompressionView()
                    .transition(.opacity)
            }
        }
    }
    
    private var lauchScreenView: some View {
        VStack {
            if !typingAnimationIsEnded {
                Spacer()
            }
            
            TypingAnimationView(text: "Grippy", animationCompletion: { typingAnimationEnded() }) { text in
                HStack {
                    Text(text)
                        .foregroundColor(.white)
                        .modifier(AnimatingFontSize(fontSize: titleFontSize))
                    
                    if typingAnimationIsEnded {
                        Spacer()
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 33)
            }
            
            Spacer()
        }.fillMaxWidth()
        .applyBackground()
    }
    
    private func typingAnimationEnded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(animation) {
                typingAnimationIsEnded = true
                titleFontSize = 22
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(animation) {
                compressionViewIsPresented = true
            }
        }
    }
    
    private struct AnimatingFontSize: AnimatableModifier {
        var fontSize: CGFloat

        var animatableData: CGFloat {
            get { fontSize }
            set { fontSize = newValue }
        }

        func body(content: Self.Content) -> some View {
            content.font(Font.custom("Pacifico-Regular", size: fontSize))
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
