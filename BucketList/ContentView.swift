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
                let url = FileManager.default.getDocumentsDirectory().appendingPathComponent("message.txt")

                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
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
