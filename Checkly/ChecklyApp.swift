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
    @StateObject var authentication = Authentication()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            if authentication.isValidated {
            tabView()
//                    .environmentObject(authentication)
//            } else {
//                LoginView()
//                    .environmentObject(authentication)
//            }
        }
    }
}
