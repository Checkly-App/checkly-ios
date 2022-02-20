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
    
    // MARK: - listen for added meetings
    func meetingNotificationListener(uid: String) {
        let ref = Database.database().reference()
        let meetingsQueue = DispatchQueue.init(label: "com.checkly.meetings-notifications")
        
        meetingsQueue.sync{
            print("start")
            ref.child("Meetings").observe(.childAdded, with: { [self] snapshot in
                let meetingNode = snapshot.value as! [String: Any]
                let agenda = meetingNode["agenda"] as! String
                let attendees = meetingNode["attendees"] as! [String: String]
                let datetime = meetingNode["datetime"] as! Int
                let host = meetingNode["host"] as! String
                let location = meetingNode["location"] as! String
                let meeting_id = meetingNode["meeting_id"] as! String
                let title = meetingNode["title"] as! String
                let type = meetingNode["type"] as! String
                
                let meeting = Meeting(id: meeting_id, host: host, title: title, dateTime: .init(timeIntervalSince1970: TimeInterval(datetime)), type: type, location: location, attendees: attendees, agenda: agenda)
                
                /// trigger a notification only if the current user was invited. i.e.,  is in the attendees list
                for attendee in attendees {
                    if uid == attendee.key && attendee.value == "Sent"{
                        print("create notification")
                        ref.child("Meetings").child("meeting_\(meeting.id)").child("attendees").updateChildValues(["\(uid)":"Notified"])
                        createMeetingNotification(meeting: meeting, attendee_id: uid)
                    }
                }
            })
            print("end")
        }
    }
    
    // MARK: - create a meeting notification
    func createMeetingNotification(meeting: Meeting, attendee_id: String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Meeting Invitation"
        content.subtitle = "You are invited to \(meeting.title)"
        content.body =  "at \(meeting.dateTime.formatted(date: .complete, time: .shortened))"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "INVITE_ACTION"
        content.userInfo = ["attendee_id": attendee_id, "host_id": meeting.host, "meeting_id": meeting.id]
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                                title: "Accept",
                                                options: UNNotificationActionOptions.init(rawValue: 0))
        let rejectAction = UNNotificationAction(identifier: "REJECT_ACTION",
                                                title: "Reject",
                                                options: UNNotificationActionOptions.init(rawValue: 0))
        let actionCategory = UNNotificationCategory(identifier: "INVITE_ACTION",
                                                    actions: [acceptAction, rejectAction],
                                                    intentIdentifiers: [],
                                                    hiddenPreviewsBodyPlaceholder: "",
                                                    options: .customDismissAction)
        
        center.setNotificationCategories([actionCategory])
        
        let notification_id = UUID().uuidString
        let request = UNNotificationRequest(identifier: notification_id, content: content, trigger: nil)
        center.add(request) { error in
            if error == nil{
                print("notification triggered")
            }
        }
    }
    
    
}
