//
//  UploadCircle.swift
//  UploadCircle
//
//  Created by Maxence Mottard on 30/07/2021.
//

import SwiftUI

struct UploadCircle: View {
    @Binding var status: Status
    @Binding var filename: String?
    @State var angle: Double = 0.0
    
    @State var outsideCircleScale = 1.0
    @State var outsideCircleOpacity = 0.5
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.white]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    ).padding(50)
                    .scaleEffect(outsideCircleScale)
                    .opacity(outsideCircleOpacity)
                    
                
                Circle()
                    .fill(status == .finish
                          ? Color.CircleLayer2Dark
                          : Color.CircleLayer2.opacity(0.5))
                    .fillMaxSize()
                
                Circle()
                    .fill(Color.CircleLayer3)
                    .fillMaxSize()
                    .padding(32)
                
                Circle()
                    .fill(Color.CircleLayer1.opacity(0.7))
                    .fillMaxSize()
                    .padding(17)
            }.padding(9)
            
            if status == .compression {
                Circle()
                    .trim(from: 0.75, to: 1)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.white]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 25, lineCap: .round)
                    )
                    .padding(14)
                    .rotationEffect(Angle(degrees: angle))
            }
            
            if status == .compression {
                Text(filename ?? "")
                    .font(.system(size: 23))
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(.horizontal, 50)
            } else if status == .finish {
                Image(systemName: "folder")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
            } else {
                Image(systemName: "icloud.and.arrow.down")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
            }
        }
        .onAppear {
            startOutsideCircleAnimation()
        }
        .onChange(of: status) { newStatus in
            guard newStatus == .compression else { return }
            
            withAnimation(self.compressionAnimation) {
                self.angle += 360.0
            }
        }
    }
    
    private func startOutsideCircleAnimation() {
        withAnimation(outsideCircleAnimation) {
            outsideCircleScale = 1.8
            outsideCircleOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            outsideCircleScale = 1
            outsideCircleOpacity = 0.5
            
            startOutsideCircleAnimation()
        }
    }
    
    private var outsideCircleAnimation: Animation {
        Animation.easeInOut(duration: 2.5)
    }
    
    private var compressionAnimation: Animation {
        Animation.easeInOut(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    enum Status {
        case upload, compression, finish
    }
}

struct UploadCircle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UploadCircle(status: .constant(.upload),
                         filename: .constant(nil))
                .previewLayout(PreviewLayout.sizeThatFits)
                .applyBackground()
            UploadCircle(status: .constant(.compression),
                         filename: .constant("LeNomde_FichierLong.pdf"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .applyBackground()
            UploadCircle(status: .constant(.finish),
                         filename: .constant("File.pdf"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .applyBackground()
        }
    }
}
