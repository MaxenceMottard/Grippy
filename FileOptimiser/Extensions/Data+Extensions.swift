//
//  Data+Extensions.swift
//  FileOptimiser
//
//  Created by Maxence Mottard on 16/06/2021.
//

import Foundation

extension Data {
    var formattedSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file

        return bcf.string(fromByteCount: Int64(self.count))
    }
}
