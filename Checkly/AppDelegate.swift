//
//  AppDelegate.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 11/02/2022.
//

import UIKit
import FirebaseDatabase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let meeting_id = response.notification.request.content.userInfo["meeting_id"]
        let attendee_id = response.notification.request.content.userInfo["attendee_id"]
        let ref = Database.database().reference()
        
        switch response.actionIdentifier{
        case "ACCEPT_ACTION":
            ref.child("Meetings").child("\(meeting_id!)").child("attendees").updateChildValues(["\(attendee_id!)":"accepted"])
            break
        case "REJECT_ACTION":
           ref.child("Meetings").child("\(meeting_id!)").child("attendees").updateChildValues(["\(attendee_id!)":"rejected"])
            break
        default:
            print("Dissmissed or Cleared Notification")
        }
        completionHandler()
    }
    
}

