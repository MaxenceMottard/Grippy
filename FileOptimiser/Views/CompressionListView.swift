//
//  CompressionListView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import SwiftUI

struct CompressionListView: View {
    @ObservedObject var viewModel: CompressionListViewModel
    
    init(data: Data) {
        self.viewModel = CompressionListViewModel(data: data)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataCompressed, id: \.algorithm.rawValue) { compressedData in
                    Button(action: { viewModel.selectedCompressedData = compressedData }) {
                        HStack {
                            Text(compressedData.algorithm.rawValue)
                            Text(compressedData.data.dataRepresentation()?.formattedSize ?? "")
                            
                            if viewModel.selectedCompressedData == compressedData {
                                Text("selected")
                            }
                        }.padding()
                    }
                }
                
//                if viewModel.selectedCompressedData != nil {
//                    PDFKitView(compressedData: $viewModel.selectedCompressedData)
//                }
            }.onAppear { viewModel.compress() }
            .onChange(of: viewModel.data) { newValue in
                viewModel.compress()
            }
        }
    }
}

struct CompressionListView_Previews: PreviewProvider {
    static var previews: some View {
        CompressionListView(data: Data())
    }
}
