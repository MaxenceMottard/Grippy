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
            
            uploadCircle
                .sheet(isPresented: $viewModel.iOSDocumentPickerIsPresented) {
                    DocumentPickerView(data: $viewModel.pickedData)
                }
            
            informationView
            bottomButton
        }
        .padding()
        .padding(.top, 40)
        .padding(.bottom, 20)
        .fillMaxWidth()
        .sheet(isPresented: $viewModel.shareSheetIsPresented, onDismiss: nil) {
            if let url = viewModel.compressedData?.url {
                ShareSheet(activityItems: [url])
            }
        }.onAppear {
            viewModel.bind()
        }.onChange(of: viewModel.compressedData) { newValue in
            guard let _ = newValue else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                changeState(.finish) {
                    viewModel.handleSaveFile()
                }
            }
        }.onChange(of: viewModel.pickedData) { newValue in
            guard let _ = newValue else { return }
            
            changeState(.compression)
        }
    }
    
    private var informationView: some View {
        let filename = viewModel.pickedData?.filename ?? ""
        let beginSize = viewModel.pickedData?.data.formattedSize ?? ""
        let endSize = viewModel.compressedData?.data.dataRepresentation()?.formattedSize ?? ""
        
        return VStack(spacing: 15) {
            if viewModel.uploadCircleStatus == .finish {
                Group {
                    Text("compressionsView.finish.label").bold()
                    Text("\(beginSize) > \(endSize)").bold()
                }
                .font(.system(size: 24))
                .foregroundColor(.white)
                .opacity(0.2)
                
                Button(action: { viewModel.handleSaveFile() }) {
                    Text("compressionsView.status.finish.button \(filename)")
                        .font(.system(size: 15))
                        .underline()
                        .bold()
                        .foregroundColor(.CircleLayer2Dark)
                        .padding()
                }
            }
        }.frame(height: 50)
    }
    
    private var bottomButton: some View {
        Group {
            switch viewModel.uploadCircleStatus {
            case .upload:
                Text("compressionsView.status.upload.label")
                    .font(.system(size: 23))
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(width: 190, height: 60)
            case .compression:
                Text("compressionsView.status.compressions.label")
                    .font(.system(size: 23))
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(height: 60)
            case .finish:
                Button(action: { reset() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Capsule().fill(Color.CircleLayer1))
                }
            }
        }
    }
    
    private func reset() {
        changeState(.upload)
        viewModel.compressedData = nil
        viewModel.pickedData = nil
    }
    
    private var uploadCircle: some View {
        UploadCircle(
            status: $viewModel.uploadCircleStatus,
            filename: $viewModel.filename)
            .onTapGesture { viewModel.handleUploadFile() }
            .frame(height: 300)
    }
    
    private func changeState(_ state: UploadCircle.Status, completion: (() -> ())? = nil) {
        withAnimation {
            viewModel.uploadCircleStatus = state
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion?()
            }
        }
    }
}
