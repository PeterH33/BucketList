//
//  EditView.swift
//  BucketList
//
//  Created by Peter Hartnett on 4/19/22.
//

import SwiftUI



struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
   
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
        self.onSave = onSave
        self.onDelete = onDelete
        self._viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                //Section for edit information
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                //Section to show the nearby wiki page information using the noted enum above
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar){
                    Button("Delete", role: .destructive){
                        
                        let deleteLocation = viewModel.location
                        onDelete(deleteLocation)
                        dismiss()
                        //TODO get a verification message for the delete
                    }
                    Button("Save") {
                        var newLocation = viewModel.location
                        newLocation.id = UUID()
                        newLocation.name = viewModel.name
                        newLocation.description = viewModel.description
                        
                        onSave(newLocation)
                        dismiss()
                    }
                }
            }
            .task {//This will kick off as soon as the view is loaded
                await viewModel.fetchNearbyPlaces()
            }
        }
    }// End Body View
    
    
    
    
}//End EditView Struct

