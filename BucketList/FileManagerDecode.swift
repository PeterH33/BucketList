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
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func decode<T: Codable>(_ fromFile: String, dataType: T) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(fromFile)
        let decoder = JSONDecoder()

        do {
            let savedData = try Data(contentsOf: url)
            do {
                let decodedData = try decoder.decode(T.self, from: savedData)
                return decodedData
            } catch {
                print(error.localizedDescription)
                print("Decoding Failed!")
            }
        } catch {
            print(error.localizedDescription)
            print("Read Failed!")
        }
        return nil
    }

    func encode<T: Codable>(_ data: T, toFile fileName: String) {
        let encoder = JSONEncoder()

        do {
            let encoded = try encoder.encode(data)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try encoded.write(to: url)
            } catch {
                print(error.localizedDescription)
                print("Write Failed!")
            }
        } catch {
            print(error.localizedDescription)
            print("Encoding Failed!")
        }
    }
}
