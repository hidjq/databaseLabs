//
//  ContentView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var vm:catViewModel = catViewModel()
    @StateObject var vmF:foodRecordViewModel = foodRecordViewModel()
    @StateObject var vmA:appearanceViewModel = appearanceViewModel()
    var body: some View {
        NavigationView {
            TabView {
                AddCatView(catLists: $vm.catLists, places: $vm.places)
                    .onAppear{
                        vm.load()
                        vm.loadPlaces()
                    }
                    .tabItem {
                        Label("add", systemImage: "plus")
                    }
                FoodRecordView(foodRecords: $vmF.foodRecords, foods: $vmF.foods, places: $vmF.places)
                    .onAppear{
                        vmF.load()
                        vmF.loadPlaces()
                        vmF.loadFoods()
                    }
                    .tabItem {
                        Label("Food", systemImage: "leaf")
                    }
                appearanceView(appearances: $vmA.appearances, places: $vmA.places)
                    .onAppear{
                        vmA.load()
                        vmA.loadPlaces()
                    }
                    .tabItem {
                        Label("Places",systemImage: "pawprint")
                    }
                Text("person")
                    .tabItem {
                        Label("Profile",systemImage: "person")
                    }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
