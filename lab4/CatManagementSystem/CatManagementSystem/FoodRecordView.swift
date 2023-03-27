//
//  FoodRecordView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/20.
//

import SwiftUI

struct FoodRecordView: View {
    @Binding var foodRecords:[FoodRecord]
    @Binding var foods:[Food]
    @Binding var places:[Place]
    @State var isEdit = false
    @State var toBeAddedFoodRecord:FoodRecord = FoodRecord(cat_name: "", food_no: 0, palce_id: 0, feed_time: "")
    @State var toBeAddedPlace:Place = Place(palce_id: 0, place_address: "", place_busytime: "")
    @State var toBeAddedFood:Food = Food(food_no: 0, food_description: "")
    @State var flagFood = true
    @State var flagPlace = true
    var body: some View {
        List {
            Section{
                Label("Add a feedRecord...", systemImage: "plus")
            }
            .onTapGesture {
                isEdit = true
            }
            
            ForEach(foodRecords,id: \.self){ foodRecord in
                let food_description:String = {
                    for food in foods {
                        if(food.food_no==foodRecord.food_no){
                            return food.food_description
                        }
                    }
                    return ""
                }()
                let place_address:String = {
                    for place in places {
                        if(place.palce_id==foodRecord.palce_id){
                            return place.place_address
                        }
                    }
                    return ""
                }()
                NavigationLink {
                    VStack(alignment: .leading) {
                        Text(foodRecord.cat_name)
                            .font(.title)
                            .bold()
                        Text("food:\(food_description)")
                        Text("Location:\(place_address)")
                        Text("feed_time:\(foodRecord.feed_time)")
                    }
                    .padding(5)
                } label: {
                    Text(foodRecord.cat_name)
                }

            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $isEdit) {
            NavigationView {
                EditFoodView(foodRecordToBeAdded: $toBeAddedFoodRecord, food: $toBeAddedFood, place: $toBeAddedPlace)
                    .navigationTitle("Add a feed Record")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEdit = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isEdit = false
                                
                                for food in foods {
                                    if(food.food_description==toBeAddedFood.food_description){
                                        flagFood = false;
                                        toBeAddedFoodRecord.food_no = food.food_no
                                        break;
                                    }
                                }
                                if(flagFood){
                                    toBeAddedFood.food_no = foods.count
                                    foods.append(toBeAddedFood)
                                    toBeAddedFoodRecord.food_no = foods.count
                                }
                                
                                for place in places {
                                    if(place.place_address==toBeAddedPlace.place_address){
                                        flagPlace = false;
                                        toBeAddedFoodRecord.palce_id=place.palce_id
                                        break;
                                    }
                                }
                                if(flagPlace){
                                    toBeAddedPlace.palce_id = places.count
                                    places.append(toBeAddedPlace)
                                    toBeAddedFoodRecord.palce_id = places.count
                                }
                                foodRecordViewModel.postFood(food: toBeAddedFood)
                                foodRecordViewModel.postPlace(place: toBeAddedPlace)
                                foodRecords.append(toBeAddedFoodRecord)
                                foodRecordViewModel.postFoodReord(foodRecord: toBeAddedFoodRecord)
                                toBeAddedFoodRecord = FoodRecord(cat_name: "", food_no: 0, palce_id: 0, feed_time: "")
                                toBeAddedFood = Food(food_no: 0, food_description: "")
                                toBeAddedPlace = Place(palce_id: 0, place_address: "")
                                
                            }
                        }
                    }
            }
        }
    }
}

//struct FoodRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodRecordView()
//    }
//}
