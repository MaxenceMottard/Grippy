//
//  CompressionViewModel.swift
//  CompressionViewModel
//
//  Created by Maxence Mottard on 30/07/2021.
//

import Foundation
import Combine
import SwiftUI
import PDFKit

final class CompressionViewModel: NSObject, ObservableObject {
    var cancelables: Set<AnyCancellable> = []
    
    //  MARK: State
    @Published var uploadCircleStatus: UploadCircle.Status = .upload
    @Published var iOSDocumentPickerIsPresented = false
    @Published var shareSheetIsPresented = false
    
    //  MARK: Data
    @Published var compressedData: CompressedData?
    @Published var pickedData: PickedDocument? = nil
    @Published var filename: String? = nil
    
    func bind() {
        $pickedData
            .sink { [compressWithQuality] newData in
                guard let pickedData = newData else { return }

                compressWithQuality(pickedData, .low)
            }.store(in: &cancelables)
        
        $pickedData
            .map { $0?.filename }
            .assign(to: \.filename, on: self)
            .store(in: &cancelables)
    }
    
    func handleUploadFile() {
        guard uploadCircleStatus == .upload else { return }
        
        iOSDocumentPickerIsPresented = true
    }
    
    func handleSaveFile() {
        shareSheetIsPresented = true
    }
    
    //  MARK: Compression
    private func compressWithQuality(document: PickedDocument, quality: UIImage.JPEGQuality) {
        guard let pdfDocument = PDFDocument(data: document.data) else { return }
        
        let finalDocument = PDFDocument()
        
        for i in 0 ..< pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: i) else {
                continue
            }
            
            let pageRect = page.bounds(for: .mediaBox)
            
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: pageRect.height))
                ctx.cgContext.translateBy(x: -pageRect.origin.x, y: pageRect.size.height - pageRect.origin.y)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                page.draw(with: .mediaBox, to: ctx.cgContext)
            }
            
            if let imageData = img.jpeg(quality),
               let resultImage = UIImage(data: imageData),
               let pdfPage = PDFPage(image: resultImage) {
                finalDocument.insert(pdfPage, at: i)
            }
        }
        
        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(document.filename)
        
        finalDocument.write(to: url)

        compressedData = CompressedData(algorithm: quality, data: finalDocument, percentOfOriginalSize: 30, url: url)
    }
}

struct CompressedData: Equatable {
    let algorithm: UIImage.JPEGQuality
    let data: PDFDocument
    let percentOfOriginalSize: Int
    let url: URL
    
    var formattedSize: String {
        return data.dataRepresentation()?.formattedSize ?? ""
    }
}
