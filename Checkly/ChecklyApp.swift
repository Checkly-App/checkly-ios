//
//  ChecklyApp.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 31/01/2022.
//

import SwiftUI
import Firebase

@main
struct ChecklyApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}

