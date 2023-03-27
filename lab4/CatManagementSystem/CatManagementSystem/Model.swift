//
//  Model.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import Foundation

struct Cat :Hashable,Codable{
    var cat_name:String
    var cat_character:String
    var palce_id:Int?
    var cat_gender:String
    var cat_color:String
    var breed_name:String 
}

struct Place:Hashable,Codable {
    var palce_id:Int
    var place_address:String
    var place_busytime:String?
}

struct Breed:Hashable,Codable{
    var breed_name:String
    var breed_description:String?
    var breed_notes:String?
}

struct ResultModel:Codable {
    var status:String
    var reason:String
}


struct FoodRecord:Codable, Hashable{
    var cat_name:String
    var food_no:Int
    var palce_id:Int
    var feed_time:String
}

struct Appearance:Codable,Hashable {
    var cat_name:String
    var palce_id:Int
    var appearance_time:String
}

struct Food:Codable {
    var food_no:Int
    var food_description:String
}
