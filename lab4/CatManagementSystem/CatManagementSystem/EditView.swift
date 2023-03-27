//
//  EditView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import SwiftUI

struct EditView: View {
    @Binding var catToBeAdded:Cat
    @Binding var placeToBeAdded:Place
    //= Cat(cat_name: "", cat_character: "", palce_id: 0, cat_gender: "", cat_color: "", breed_name: "")
    var body: some View {
        Form {
            TextField("name", text: $catToBeAdded.cat_name)
            TextField("character", text: $catToBeAdded.cat_character)
            TextField("gender", text: $catToBeAdded.cat_gender)
            TextField("color", text: $catToBeAdded.cat_color)
            TextField("breed", text: $catToBeAdded.breed_name)
            TextField("Place",text: $placeToBeAdded.place_address)
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
