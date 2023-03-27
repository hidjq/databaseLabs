//
//  CatManagementSystemApp.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/15.
//

import SwiftUI

@main
struct CatManagementSystemApp: App {
    @State var isLogin = false
    var body: some Scene {
        WindowGroup {
            if isLogin {
                ContentView()
            } else {
                loginView(isLogin: $isLogin)
            }
        }
    }
}
