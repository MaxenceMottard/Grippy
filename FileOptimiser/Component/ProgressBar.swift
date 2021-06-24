//
//  ProgressBar.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 24/06/2021.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProgressBar(value: .constant(0.5))
            ProgressBar(value: .constant(0.2))
            ProgressBar(value: .constant(0.8))
        }.previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .frame(height: 15)
    }
}
