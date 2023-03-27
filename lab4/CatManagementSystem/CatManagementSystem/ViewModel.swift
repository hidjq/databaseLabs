//
//  ViewModel.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/16.
//

import Foundation
import SwiftyJSON
class catViewModel:ObservableObject {
    @Published var catLists:[Cat] = [] 
    @Published var places:[Place] = []
    init(){
        load()
        loadPlaces()
    }
    
    //MARK: - load data from database
    
    func load(){
        guard let url = URL(string:"http://localhost:8081/getall") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Cat].self, from: data)
                    DispatchQueue.main.async {
                        self.catLists = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    func loadPlaces(){
        guard let url = URL(string:"http://localhost:8081/getplaces") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Place].self, from: data)
                    DispatchQueue.main.async {
                        self.places = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
    }
    //MARK: - update data to database
    
    static func postPlace(place:Place){
        guard let url = URL(string:"http://localhost:8081/postplace") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["place_id":place.palce_id,"place_address":place.place_address,"place_busytime":place.place_busytime])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    static func postBreed(breed:Breed){
        guard let url = URL(string:"http://localhost:8081/postbreed") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["breed_name":breed.breed_name,"breed_description":breed.breed_description,"breed_notes":breed.breed_notes])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    static func postCat(cat:Cat){
        guard let url = URL(string:"http://localhost:8081/postcat") else {
            print("Not fund url")
            return
        }
        do {
            
            let data = try JSONSerialization.data(withJSONObject: ["cat_name":cat.cat_name,"cat_character":cat.cat_character,"palce_id":cat.palce_id,"cat_gender":cat.cat_gender,"cat_color":cat.cat_color,"breed_name":cat.breed_name])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            URLSession.shared.dataTask(with: request) { data, res, error in
                if error != nil {
                    print("error",error?.localizedDescription ?? "")
                    return
                }
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(ResultModel.self, from: data)
                        DispatchQueue.main.async {
                            print(result)
                        }
                    } else {
                        print("No data")
                    }
                } catch let JsonError {
                    print("fetch json error:",JsonError.localizedDescription)
                }
            }.resume()
            
        } catch let e{
            print("error",e.localizedDescription)
        }
        
    }
    
}


class foodRecordViewModel:ObservableObject {
    @Published var foodRecords:[FoodRecord] = []
    @Published var places:[Place] = []
    @Published var foods:[Food] = []
    init(){
        load()
        loadPlaces()
        loadFoods()
    }
    
    //MARK: - load data from database
    
    func load(){
        guard let url = URL(string:"http://localhost:8081/getallfoodRecord") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([FoodRecord].self, from: data)
                    DispatchQueue.main.async {
                        self.foodRecords = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    func loadPlaces(){
        guard let url = URL(string:"http://localhost:8081/getplaces") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Place].self, from: data)
                    DispatchQueue.main.async {
                        self.places = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
    }
    func loadFoods(){
        guard let url = URL(string:"http://localhost:8081/getfoods") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Food].self, from: data)
                    DispatchQueue.main.async {
                        self.foods = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
    }
    //MARK: - update data to database
    
    static func postPlace(place:Place){
        guard let url = URL(string:"http://localhost:8081/postplace") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["place_id":place.palce_id,"place_address":place.place_address,"place_busytime":place.place_busytime])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    
    
    static func postFood(food:Food){
        guard let url = URL(string:"http://:8081/postfood") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["food_no":food.food_no,"food_description":food.food_description])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    static func postFoodReord(foodRecord:FoodRecord){
        guard let url = URL(string:"http://localhost:8081/postFoodRecord") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["cat_name":foodRecord.cat_name,"food_no":foodRecord.food_no,"place_id":foodRecord.palce_id,"feed_time":foodRecord.feed_time])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
}


class appearanceViewModel:ObservableObject {
    @Published var appearances:[Appearance] = []
    @Published var places:[Place] = []
    init(){
        load()
        loadPlaces()
    }
    
    //MARK: - load data from database
    
    func load(){
        guard let url = URL(string:"http://localhost:8081/getallappearance") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Appearance].self, from: data)
                    DispatchQueue.main.async {
                        self.appearances = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    //MARK: - update data to database
    func loadPlaces(){
        guard let url = URL(string:"http://localhost:8081/getplaces") else {
            print("Not fund url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Place].self, from: data)
                    DispatchQueue.main.async {
                        self.places = result
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
    }
    
    static func postPlace(place:Place){
        guard let url = URL(string:"http://localhost:8081/postplace") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["place_id":place.palce_id,"place_address":place.place_address,"place_busytime":place.place_busytime])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    
    static func postBreed(breed:Breed){
        guard let url = URL(string:"http://localhost:8081/postbreed") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["breed_name":breed.breed_name,"breed_description":breed.breed_description,"breed_notes":breed.breed_notes])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
    static func postAppearance(appearance:Appearance){
        guard let url = URL(string:"http://localhost:8081/postappearance") else {
            print("Not fund url")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["cat_name":appearance.cat_name,"place_id":appearance.palce_id,"appearance_time":appearance.appearance_time])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ResultModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError {
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        
    }
    
}
