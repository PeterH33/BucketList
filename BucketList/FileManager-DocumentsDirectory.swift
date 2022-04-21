//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/21/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
