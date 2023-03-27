//
//  EditAppearanceView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/21.
//

import SwiftUI

struct EditAppearanceView: View {
    @Binding var appearanceToBeAdded:Appearance
    @Binding var place:Place
    var body: some View {
        Form {
            TextField("name", text: $appearanceToBeAdded.cat_name)
            TextField("place", text: $place.place_address)
            TextField("time", text: $appearanceToBeAdded.appearance_time)
        }
    }
}

//struct EditAppearanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditAppearanceView()
//    }
//}
