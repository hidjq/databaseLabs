//
//  AddCatView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import SwiftUI

struct AddCatView: View {
    @Binding var catLists:[Cat]
    @Binding var places:[Place]
    @State var isEdit = false
    @State var toBeAddedCat:Cat = Cat(cat_name: "", cat_character: "", palce_id: 0, cat_gender: "", cat_color: "", breed_name: "")
    @State var toBeAddedplace:Place = Place(palce_id: 0, place_address: "",place_busytime: "")
    @State var flag = true
    var body: some View {
        List {
            Section{
                Label("Add a cat...", systemImage: "plus")
            }
            .onTapGesture {
                isEdit = true
            }
            
            ForEach(catLists,id: \.self){ cat in
                NavigationLink {
                    CatView(cat: cat,place: {
                        for place in places {
                            print(place)
                            if(place.palce_id==cat.palce_id){
                                return place
                            }
                        }
                        return Place(palce_id: 0, place_address: "")
                    }())
                } label: {
                    Text(cat.cat_name)
                }

            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $isEdit) {
            NavigationView {
                EditView(catToBeAdded: $toBeAddedCat, placeToBeAdded: $toBeAddedplace)
                    .navigationTitle("Add a Cat")
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
                                    if(place.place_address==toBeAddedplace.place_address){
                                        flag = false;
                                        toBeAddedCat.palce_id = place.palce_id
                                        break;
                                       }
                                }
                                if(flag){
                                    toBeAddedplace.palce_id = places.count
                                    toBeAddedCat.palce_id = places.count
                                    catViewModel.postPlace(place: toBeAddedplace)
                                    places.append(toBeAddedplace)
                                }
                                catViewModel.postBreed(breed: Breed(breed_name: toBeAddedCat.breed_name, breed_description: "de", breed_notes: "notes"))
                                catLists.append(toBeAddedCat)
                                catViewModel.postCat(cat: toBeAddedCat)
                                toBeAddedCat = Cat(cat_name: "", cat_character: "",palce_id: 0, cat_gender: "", cat_color: "", breed_name: "")
                            }
                        }
                    }
            }
        }
    }
}

//struct AddCatView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCatView()
//    }
//}
