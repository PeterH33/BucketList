//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/22/22.
//

import Foundation
import SwiftUI

//Challenge 3, pulled out all of the logic from the EditView and placed it in the Model file, thought this would be more complicated than it was, but this seems to work well.
extension EditView{
    
    @MainActor class ViewModel: ObservableObject{
    
        init(location: Location){
            self.location = location
            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }
        

        //Using this to show and store loading states
        enum LoadingState {
            case loading, loaded, failed
        }
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]() //stores the loaded wiki pages when they have been fetched.
        @Published var name: String
        @Published var description: String
        
        var location: Location
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
    }
    
}
