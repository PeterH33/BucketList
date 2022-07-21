//
//  ContentView.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/16/22.
//
//******** Challenges **************

//1) Our + button is rather hard to tap. Try moving all its modifiers to the image inside the button – what difference does it make, and can you think why?
//2) Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert.
//3) Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model.
//   Tip: That last challenge will require you to make StateObject instance in your EditView initializer – remember to use an underscore with the property name!

import SwiftUI
import MapKit
import LocalAuthentication



struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    //This init() goes along with the @StateObject -> MainActor architecture in order to eliminate problems at compile time, will be an error in Xcode 6 initializers are not async, this clears it up.
    //TODO: Apple went back on this change, remove it when I have time
    init() {
        self._viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    
    var body: some View {
        ZStack {
            if viewModel.isUnlocked == true{
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }//End map annotation Vstack
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // create a new location
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                            //Challenge #1 I hadn't noticed the issues with tapping the button until this challenge was mentioned, however it does become clear after the change. The reason for the shift is that in the initial situation it is only the plus symbol itself that is functioning as a button, after moving the modifiers to the image label all of the visual components are included in the button itself, you can also see the change as the whole button changes transparency after it is hit.
                            //This is a handy thing to consider, making sure that what you want to be considered the button is actually in the right location of a button declaration.
                        }
                    }
                }
            } //end unlock check
            else{
                //Auth button view
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }//End ZStack
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }onDelete: { deleteLocation in
                viewModel.deleteLocation(deleteThis: deleteLocation)
            }
            
            
        }
        .alert("Authentication Failed Try again", isPresented: $viewModel.authFailed){
            Button("OK"){}
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
