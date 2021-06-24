//
//  CompressionListView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import SwiftUI

struct CompressionListView: View {
    @ObservedObject var viewModel: CompressionListViewModel
    
    init(pickedDocument: PickedDocument) {
        self.viewModel = CompressionListViewModel(pickedDocument: pickedDocument)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataCompressed, id: \.algorithm.rawValue) { compressedData in
                    NavigationLink(destination: PDFPreviewView(compressedData: compressedData, filename: viewModel.pickedDocument.filename)) {
                        VStack {
                            HStack {
                                Text(compressedData.algorithm.name)
                                
                                if viewModel.selectedCompressedData == compressedData {
                                    Text("selected")
                                }
                            }
                            
                            Text("\(viewModel.pickedDocument.data.formattedSize) to \(compressedData.formattedSize) (\(compressedData.percentOfOriginalSize)%)")
                            ProgressBar(value: .constant(Float(compressedData.percentOfOriginalSize) / 100.0))
                        }.padding()
                        .background(Color.red)
                        .padding()
                    }
                }
            }.onAppear { viewModel.compress() }
            .onChange(of: viewModel.pickedDocument) { newValue in
                viewModel.compress()
            }
        }
    }
}

struct CompressionListView_Previews: PreviewProvider {
    static var previews: some View {
        CompressionListView(pickedDocument: PickedDocument(data: Data(), filename: "Filename"))
    }
}
