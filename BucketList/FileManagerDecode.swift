//
//  FileManagerDecode.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/16/22.
//

import Foundation

import SwiftUI


extension FileManager {
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    func decode(_ file: String) -> String {
         let url = self.getDocumentsDirectory().appendingPathComponent(file) 
        
        
        
        guard let input = try? String(contentsOf: url) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        
        return input
    }
}
