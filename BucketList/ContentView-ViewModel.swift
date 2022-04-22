//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/21/22.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView{
    
    //@MainACtor is nessisary when the class is going to be working on the UI and looking for updates there, swift can infer it often.
    @MainActor class ViewModel: ObservableObject{
        
        init() {
            do {
                //trys to load up the data from the save file path on initial load.
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        //Map location state that starts off over europe and will track the centerpoint of the map.
        //in mvvm these would be states and private, using them in a class like this we label them as @published and make them public
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        //Adding private(set) makes it so that only this class can set the value, helps to keep logic isolated from view
        @Published private(set) var locations: [Location]
        
        //Function for that mentioned manipulation of data
        func addLocation(){
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        @Published var selectedPlace: Location?
        func update(location: Location){
            //Check that there is a selected place as that @published is an optional
            guard let selectedPlace = selectedPlace else {return}
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()
        }
        
        //Just to store the save file and keep it consistant.
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                //Note .compelteFileprotection option encrypts the data so that it can only be read when the phone is unlocked. But alone it will not do anything if the phone is already unlocked and someone looks at the program, that requires an unlock screen in app
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func deleteLocation(deleteThis: Location){
            locations.removeAll() {$0 == deleteThis  }
            save()
        }
        
        @Published var isUnlocked = false
        @Published var authFailed = false
        //TODO  add in a failure count to swap over to a code based system after several fails, also just put in a button to go straight to number code instead of face
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            // check whether biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // it's possible, so go ahead and use it
                let reason = "We need to unlock your data."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    if success {
                        // authenticated successfully
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        Task { @MainActor in
                            self.authFailed = true //This should trigger the alert for an auth failed message
                        }
                        // there was a problem, auth failed write code to try again or to go with keypad instead
                    }
                }
            } else {
                //Add in keypad passcode system here for when biometrics isnt avail
                
            }
        }
        
    }
}
