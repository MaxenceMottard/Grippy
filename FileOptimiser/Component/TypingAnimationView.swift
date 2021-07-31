//
//  TypingAnimationView.swift
//  TypingAnimationView
//
//  Created by Maxence Mottard on 31/07/2021.
//

import SwiftUI

struct TypingAnimationView<V: View>: View {
    @State var text: String
    @State private var textArray: [String]
    
    let animationContent: (String) -> (V)
    let animationCompletion: (() -> ())?
    
    init(text: String, animationCompletion: (() -> ())? = nil, animationContent: @escaping (String) -> (V)) {
        self.text = text
        self.textArray = text.map { String($0) }
        self.animationCompletion = animationCompletion
        self.animationContent = animationContent
    }
    
    var body: some View {
        animationContent(text)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    removeTextChar()
                }
            }.onChange(of: textArray) {
                text = $0.joined()
            }
    }
    
    private func removeTextChar() {
        guard textArray.count > 1 else {
            animationCompletion?()

            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            textArray.removeLast()
            
            removeTextChar()
        }
    }
}
