//
//  PDFKitView.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import PDFKit
import UIKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    @Binding var compressedData: CompressedData?
    
    init(compressedData: Binding<CompressedData?>) {
        self._compressedData = compressedData
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFKitView.UIViewType {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let compressedData = self.compressedData {
            pdfView.document = compressedData.data
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        if let compressedData = self.compressedData {
            uiView.document = compressedData.data
        }
    }
}
