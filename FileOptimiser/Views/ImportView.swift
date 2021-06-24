//
//  ImportView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import SwiftUI
import PDFKit

struct ImportView: View {
    @State var pickedData: PickedDocument? = nil
    @State var documentPickerIsPresented = false
    @State var activityViewIsPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let pickedData = pickedData {
                    CompressionListView(pickedDocument: pickedData)
                } else {
                    Text("Import file")
                        .padding()
                }
            }.sheet(isPresented: $documentPickerIsPresented) {
                DocumentPickerView(data: $pickedData)
            }.toolbar {
                Button(action: { documentPickerIsPresented = true }) {
                    Image(systemName: "arrow.down.app")
                }
            }
            
//            VStack {
//
//            PDFKitView(compressedData: $selectedCompressedData)
//                .navigationBarItems(leading: EmptyView(), trailing: saveButton)
//                
//                ActivityView(isPresented: $activityViewIsPresented, items: [selectedCompressedData?.data], activities: nil) { _, _, _, _ in
//                    print("share")
//                }
//            }
        }
    }
    
    var saveButton: some View {
        Button { activityViewIsPresented = true } label: {
            Image(systemName: "square.and.arrow.down")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
