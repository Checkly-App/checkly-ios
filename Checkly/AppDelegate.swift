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
            print("accepted")
//            ref.child("Meetings").child("meeting_\(meeting_id!)").child("attendees").updateChildValues(["\(attendee_id)":"Accepted"])
            break
        case "REQUEST_ACTION":
            print("rejected")
//            ref.child("Meetings").child("meeting_\(meeting_id!)").child("attendees").updateChildValues(["\(attendee_id)":"Rejected"])
            break
        default:
            print("Dissmissed or Cleared Notification")
        }
        completionHandler()
    }
    
}

