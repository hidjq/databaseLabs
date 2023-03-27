//
//  EditFoodView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/20.
//

import SwiftUI

struct EditFoodView: View {
    @Binding var foodRecordToBeAdded:FoodRecord
    @Binding var food:Food
    @Binding var place:Place
    var body: some View {
        Form {
            TextField("name", text: $foodRecordToBeAdded.cat_name)
            TextField("food", text: $food.food_description)
            TextField("place", text: $place.place_address)
            TextField("time", text: $foodRecordToBeAdded.feed_time)
        }
    }
}
