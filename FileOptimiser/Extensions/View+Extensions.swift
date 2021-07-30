//
//  View+Extensions.swift
//  View+Extensions
//
//  Created by Maxence Mottard on 30/07/2021.
//

import SwiftUI
import UIKit

extension View {
    func fillMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func fillMaxHeight(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func fillMaxSize(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    func applyBackground() -> some View {
        return self.background(
            ZStack(alignment: .bottom) {
                Color.Background
//                    .fillMaxWidth()
                
                LinearGradient(
                    gradient: Gradient(colors: [.CircleLayer3.opacity(0), .CircleLayer3]),
                    startPoint: .top, endPoint: .bottom
                ).frame(height: UIScreen.main.bounds.height * 0.65)
            }.edgesIgnoringSafeArea(.all)
        )
    }
}
