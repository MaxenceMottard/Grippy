//
//  PickedDocumentDelegate.swift
//  PickedDocumentDelegate
//
//  Created by Maxence Mottard on 01/08/2021.
//

import Foundation

protocol PickedDocumentDelegate {
    
}

extension PickedDocumentDelegate {
    func formatData(urls: [URL]) -> PickedDocument {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
            return PickedDocument(data: Data(), filename: "")
        }
        
        do {
            let filename = url.lastPathComponent
            let fileData = try Data(contentsOf: url)

            url.stopAccessingSecurityScopedResource()

            return PickedDocument(data: fileData, filename: filename)
        } catch(let error) {
            print(error)
            
            return PickedDocument(data: Data(), filename: "")
        }
    }
}
