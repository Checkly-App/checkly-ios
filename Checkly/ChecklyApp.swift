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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabNavigationView()
            } else {
                LoginView()
            }
        }
    }
}

