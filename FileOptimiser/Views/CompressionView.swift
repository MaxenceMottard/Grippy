//
//  CompressionView.swift
//  CompressionView
//
//  Created by Maxence Mottard on 30/07/2021.
//

import SwiftUI

struct CompressionView: View {
    @ObservedObject var viewModel = CompressionViewModel()
    
    var body: some View {
        VStack(spacing: 70) {
            Spacer()
            
            UploadCircle(
                status: $viewModel.uploadCircleStatus,
                filename: $viewModel.filename)
                .onTapGesture { viewModel.handleUploadFile() }
                .sheet(isPresented: $viewModel.documentPickerIsPresented) {
                    DocumentPickerView(data: $viewModel.pickedData)
                }
            
            Text("Terminé")
                .font(.system(size: 55))
                .bold()
                .foregroundColor(.white)
                .opacity(viewModel.uploadCircleStatus == .finish ? 0.2 : 0)
            
            switch viewModel.uploadCircleStatus {
            case .upload:
                Text("Insérez un fichier à compresser")
                    .font(.system(size: 23))
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(width: 190, height: 60)
            case .compression:
                Text("Compression en cours...")
                    .font(.system(size: 23))
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(height: 60)
            case .finish:
                Button(action: { viewModel.handleSaveFile() }) {
                    Text("Télécharger")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.horizontal, 60)
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .background(Capsule().fill(Color.CircleLayer1))
                }
            }
        }
        .padding()
        .padding(.vertical, 40)
        .fillMaxWidth()
        .sheet(isPresented: $viewModel.shareSheetIsPresented, onDismiss: nil) {
            if let url = viewModel.compressedData?.url {
                ShareSheet(activityItems: [url])
            }
        }.onAppear {
            viewModel.bind()
        }
    }
}

//struct CompressionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompressionView()
//    }
//}
