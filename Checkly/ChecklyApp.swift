//
//  ChecklyApp.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 31/01/2022.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct ChecklyApp: App {
    @StateObject var authentication = Authentication()
    
    //MARK: - AppDelegate Connection
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //MARK: - @Observed Object
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: "location") == false {
                LocationRequestView()
            }else{
                MainView()
            }
        }
    }
}

