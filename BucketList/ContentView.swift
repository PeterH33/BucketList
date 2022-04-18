//
//  ContentView.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/16/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    
    
    var body: some View {
        Text("Hello World")
            .onTapGesture {
                let str = "Test Message"
                
                let fileName = "message.txt"
                do {
                    try FileManager.default.encode(str, toFile: fileName)
                    let input = try FileManager.default.decode(fileName, dataType: "String")
                    print("Here is the file decoded \(input ?? "ERROR FAILURE")")
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
