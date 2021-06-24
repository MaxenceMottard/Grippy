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
    let data: Data
    
    @Published var selectedCompressedData: CompressedData?
    
    init(data: Data) {
        self.data = data
    }
    
    func compress() {
        guard let document = PDFDocument(data: data) else { return }
        
        let finalDocument = PDFDocument()
        
        for i in 0 ..< document.pageCount {
            print(i)
            guard let page = document.page(at: i),
                let pageData = page.dataRepresentation else {
                continue
            }
            
            let pageRect = page.bounds(for: .mediaBox)
            
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                // Set and fill the background color.
                UIColor.white.set()
                ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: pageRect.height))
                
                // Translate the context so that we only draw the `cropRect`.
                ctx.cgContext.translateBy(x: -pageRect.origin.x, y: pageRect.size.height - pageRect.origin.y)
                
                // Flip the context vertically because the Core Graphics coordinate system starts from the bottom.
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                
                // Draw the PDF page.
                page.draw(with: .mediaBox, to: ctx.cgContext)
            }
            
            //            if let image = UIImage(data: pageData),
            if let imageData = img.jpeg(.medium),
               let resultImage = UIImage(data: imageData),
               let pdfPage = PDFPage(image: resultImage) {
                print(imageData.formattedSize)
                
                finalDocument.insert(pdfPage, at: i)
            }
        }
        
        self.dataCompressed = [
            CompressedData(algorithm: .original, data: document),
            CompressedData(algorithm: .zlib, data: finalDocument)
        ]
    }
}

struct CompressedData: Equatable {
    let algorithm: CompressionType
    let data: PDFDocument
}

enum CompressionType: String {
    case lz4 = "lz4"
    case lzma = "lzma"
    case zlib = "zlib"
    case lzfse = "lzfse"
    case original = "original"
    
    init(algorithm compression: NSData.CompressionAlgorithm) {
        switch compression {
        case .lzfse:
            self = .lzfse
        case .lz4:
            self = .lz4
        case .lzma:
            self = .lzma
        case .zlib:
            self = .zlib
        @unknown default:
            self = .original
        }
    }
}
