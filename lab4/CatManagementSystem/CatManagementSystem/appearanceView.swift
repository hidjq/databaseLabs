//
//  appearanceView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/21.
//

import SwiftUI

struct appearanceView: View {
    @Binding var appearances:[Appearance]
    @Binding var places:[Place]
    @State var isEdit = false
    @State var toBeAddedAppearance:Appearance = Appearance(cat_name: "", palce_id: 0, appearance_time: "")
    @State var toBeAddedPlace:Place = Place(palce_id: 0, place_address: "", place_busytime: "busy")
    @State var flagPlace = true
    
    
    var body: some View {
        List {
            Section{
                Label("Add a appearance...", systemImage: "plus")
            }
            .onTapGesture {
                isEdit = true
            }
            
            ForEach(appearances,id: \.self){ appearance in
                var place_address:String = {
                    for place in places {
                        if(place.palce_id==appearance.palce_id){
                            return place.place_address
                        }
                    }
                    return ""
                }()
                NavigationLink {
                    VStack(alignment: .leading) {
                        Text(appearance.cat_name)
                            .font(.title)
                            .bold()
                        Text("place_address:\(place_address)")
                        Text("appearance_time:\(appearance.appearance_time)")
                    }
                    .padding(5)
                } label: {
                    Text(appearance.cat_name)
                }

            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $isEdit) {
            NavigationView {
                EditAppearanceView(appearanceToBeAdded: $toBeAddedAppearance, place: $toBeAddedPlace)
                    .navigationTitle("Add an appearance")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEdit = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isEdit = false
                                for place in places {
                                    if(place.place_address==toBeAddedPlace.place_address){
                                        flagPlace = false;
                                        toBeAddedAppearance.palce_id=place.palce_id
                                        break;
                                    }
                                }
                                if(flagPlace){
                                    toBeAddedPlace.palce_id = places.count
                                    appearanceViewModel.postPlace(place: toBeAddedPlace)
                                    places.append(toBeAddedPlace)
                                    toBeAddedAppearance.palce_id = places.count
                                }
                                appearances.append(toBeAddedAppearance)
                                appearanceViewModel.postAppearance(appearance: toBeAddedAppearance)
                                toBeAddedAppearance = Appearance(cat_name: "", palce_id: 0, appearance_time: "")
                                toBeAddedPlace = Place(palce_id: 0, place_address: "", place_busytime: "")
                                
                            }
                        }
                    }
            }
        }
    }
}

//struct appearanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        appearanceView()
//    }
//}
