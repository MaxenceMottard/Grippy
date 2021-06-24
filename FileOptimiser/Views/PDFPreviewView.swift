//
//  PDFPreviewView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 24/06/2021.
//

import SwiftUI
import PDFKit
import UIKit

struct PDFPreviewView: View {
    let compressedData: CompressedData
    let filename: String
    @State var activityViewIsPresented: Bool = false
    
    var body: some View {
        PDFKitView(compressedData: compressedData)
            .navigationBarItems(leading: EmptyView(), trailing: saveButton)
            .sheet(isPresented: $activityViewIsPresented, onDismiss: nil) {
                if let data = compressedData.data.dataRepresentation() {
                    ShareSheet(activityItems: [data])
                }
            }.navigationTitle("\(filename) - \(compressedData.algorithm.name)")
    }
    
    var saveButton: some View {
        Button { activityViewIsPresented = true } label: {
            Image(systemName: "square.and.arrow.down")
        }
    }
}

struct PDFPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PDFPreviewView(
            compressedData: CompressedData(algorithm: .original, data: PDFDocument(data: Data())!, percentOfOriginalSize: 60),
            filename: "Filename.pdf"
        )
    }
}
