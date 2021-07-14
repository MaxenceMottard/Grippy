//
//  CompressionListViewModel.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import Foundation
import SwiftUI
import Combine
import PDFKit

final class CompressionListViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    
    @Published var dataCompressed: [CompressedData] = []
    let algorithms: [NSData.CompressionAlgorithm] = [.lz4, .lzma, .zlib, .lzfse]
    let pickedDocument: PickedDocument
    
    @Published var selectedCompressedData: CompressedData?
    
    init(pickedDocument: PickedDocument) {
        self.pickedDocument = pickedDocument
    }
    
    func compress() {
        guard let document = PDFDocument(data: pickedDocument.data) else { return }
        
        let originalDocument = CompressedData(algorithm: .original, data: document, percentOfOriginalSize: 100)

        self.dataCompressed = [
            originalDocument,
            compressWithQuality(document: document, quality: .low),
            compressWithQuality(document: document, quality: .medium),
            compressWithQuality(document: document, quality: .high),
        ]
    }
    
    private func compressWithQuality(document: PDFDocument, quality: UIImage.JPEGQuality) -> CompressedData {
        let finalDocument = PDFDocument()
        
        for i in 0 ..< document.pageCount {
            guard let page = document.page(at: i) else {
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
        
        let percent = 100 * (finalDocument.dataRepresentation()?.count ?? 0) / pickedDocument.data.count
        
        return CompressedData(algorithm: quality, data: finalDocument, percentOfOriginalSize: percent)
    }
}

struct CompressedData: Equatable {
    let algorithm: UIImage.JPEGQuality
    let data: PDFDocument
    let percentOfOriginalSize: Int
    
    var formattedSize: String {
        return data.dataRepresentation()?.formattedSize ?? ""
    }
}

