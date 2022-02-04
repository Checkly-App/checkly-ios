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
    @AppStorage("isLoggedIn") var isLoggedIn = false // To maintain the users sessions

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView() // Home view
            } else {
                LoginView()
            }
        }
    }
}

