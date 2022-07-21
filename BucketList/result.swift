//
//  result.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/20/22.
//

import SwiftUI

//TODO extract the function from Edit view fetchNearbyPlaces() and make it a useful standalone function for pulling Wikipedia information.

//This struct is used to show information pulled out of wikipedia
//Wikipedia’s API sends back JSON data in a precise format, so we need to do a little work to define Codable structs capable of storing it all. The structure is this:
//
//The main result contains the result of our query in a key called “query”.
//Inside the query is a “pages” dictionary, with page IDs as the key and the Wikipedia pages themselves as values.
//Each page has a lot of information, including its coordinates, title, terms, and more.
//We can represent that using three linked structs

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    //To conform to comparable, and hence be able to be sorted you simply need to add this function, which the stubs will be provided
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title //This is the line that lets you set the comparable aspect
    }
    //This is used to fetch the wiki pages description because of a failing on wikipedias part where the description is quite burried.
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
