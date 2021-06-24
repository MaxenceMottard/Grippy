//
//  ImportView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import SwiftUI
import PDFKit

struct ImportView: View {
    @State var fileData: Data? = nil
    @State var compressionViewIsPresented = false
    @State var documentPickerIsPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let data = fileData {
                    CompressionListView(data: data)
                } else {
                    Text("Import file")
                        .padding()
                }
            }.sheet(isPresented: $documentPickerIsPresented) {
                DocumentPickerView(data: $fileData)
            }.onChange(of: fileData) { newValue in
                compressionViewIsPresented = true
            }.toolbar {
                Button(action: { documentPickerIsPresented = true }) {
                    Image(systemName: "arrow.down.app")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(fileData: Data())
    }
}
