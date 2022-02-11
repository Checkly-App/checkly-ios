//
//  NotificationManager.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 11/02/2022.
//

import SwiftUI
import Foundation
import UserNotifications
import FirebaseDatabase

class NotificationManager {
    
    static let instance = NotificationManager()
    
    // MARK: - request user premision when they first download the app
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
                print("Error, \(error)")
            } else {
                print("success")
            }
        }
    }
    
    // MARK: - trigger a meeting when the user has a meeting
    func meetingNotificationListener(uid: String) {
        print("\(uid)")
        let ref = Database.database().reference()
        let meetingsQueue = DispatchQueue.init(label: "meetingsQueue")
        
        _ = meetingsQueue.sync {
            ref.child("Meetings").observe(.childAdded, with: { [self] snapshot in
                let meetingNode = snapshot.value as! [String: Any]
                let agenda = meetingNode["agenda"] as! String
                let attendees = meetingNode["attendees"] as! String
                let datetime = meetingNode["datetime"] as! Int
                let host = meetingNode["host"] as! String
                let location = meetingNode["location"] as! String
                let meeting_id = meetingNode["meeting_id"] as! String
                let title = meetingNode["title"] as! String
                let type = meetingNode["type"] as! String
                
                
                let meeting = Meeting(id: meeting_id, host: host, title: title, dateTime: .init(timeIntervalSince1970: TimeInterval(datetime)), type: type, location: location, attendees: attendees, agenda: agenda)
                let attendeesList = attendees.components(separatedBy: ", ")
                
                /// trigger a notification only if the current user was invited. i.e.,  is in the attendees list
                if attendeesList.contains(uid) {
                    createMeetingNotification(meeting: meeting)
                }
            })
        }
    }
    
    func createMeetingNotification(meeting: Meeting){
        
    }
}
