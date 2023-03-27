//
//  CatView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import SwiftUI

struct CatView: View {
    var cat:Cat
    var place:Place
    var body: some View {
        VStack(alignment: .leading) {
            Text(cat.cat_name)
                .font(.title)
                .bold()
            
            Text("gender:\(cat.cat_gender)")
                .padding(5)
            
            Text("character:\(cat.cat_character)")
                .padding(5)
            
            Text("color:\(cat.cat_color)")
                .padding(5)
            Text("breedName:\(cat.breed_name)")
                .padding(5)
            Text("place:\(place.place_address)")
                .padding(5)
            
        }
        .padding(5)
    }
}

//struct CatView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatView(cat: Cat(cat_name: "mimi", cat_character: "soft", palce_id: 1, cat_gender: "M", cat_color: "white", breed_name: "yingduan"))
//            .background(.yellow)
//            .previewLayout(.fixed(width: 400, height: 60))
//    }
//}
