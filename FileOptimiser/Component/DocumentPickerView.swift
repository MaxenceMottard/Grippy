//
//  DocumentPickerView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import UIKit
import SwiftUI
import MobileCoreServices

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var data: PickedDocument?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = context.coordinator
        documentPicker.allowsMultipleSelection = false
        
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: $data)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var data: PickedDocument?
        
        init(data: Binding<PickedDocument?>) {
            self._data = data
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first,
                  url.startAccessingSecurityScopedResource() else { return }
            
            do {
                let filename = url.lastPathComponent
                let fileData = try Data(contentsOf: url)
                
                self.data = PickedDocument(data: fileData, filename: filename)
            } catch(let error) {
                print(error)
            }
            
            url.stopAccessingSecurityScopedResource()
        }
    }
}

struct PickedDocument: Equatable {
    let data: Data
    let filename: String
}
