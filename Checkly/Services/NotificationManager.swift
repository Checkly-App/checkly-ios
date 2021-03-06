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
    
    // MARK: - request user permission when they first download the app
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
    
    // MARK: - listen for any added meetings
    func meetingNotificationListener(uid: String) {
        let ref = Database.database().reference()
        let meetingsQueue = DispatchQueue.init(label: "com.checkly.meetings-notifications")
        
        _ = meetingsQueue.sync{
            ref.child("Meetings").observe(.childAdded, with: { [self] snapshot in
                let meetingNode = snapshot.value as! [String: Any]
                let agenda = meetingNode["agenda"] as! String
                let attendees = meetingNode["attendees"] as! [String: String]
                let datetime_start = meetingNode["datetime_start"] as! Int
                let datetime_end = meetingNode["datetime_end"] as! Int
                let decisions = meetingNode["decisions"] as! String
                let host = meetingNode["host"] as! String
                let latitude = meetingNode["latitude"] as! String
                let location = meetingNode["location"] as! String
                let longitude = meetingNode["longitude"] as! String
                let title = meetingNode["title"] as! String
                let type = meetingNode["type"] as! String
                let meeting_id = snapshot.key
                
                let meeting = Meeting(id: meeting_id, host: host, title: title, datetime_start: .init(timeIntervalSince1970: TimeInterval(datetime_start)), datetime_end: .init(timeIntervalSince1970: TimeInterval(datetime_end)), type: type, location: location, attendees: attendees, agenda: agenda, latitude: latitude, longitude: longitude, decisions: decisions)
                
                for attendee in attendees {
                    /// trigger a notification only if the current user was invited. i.e.,  is in the attendees list
                    if uid == attendee.key && attendee.value == "sent"{
                        print("create notification \(uid) and \(attendee.key)")
                        ref.child("Meetings").child("\(meeting.id)").child("attendees").updateChildValues(["\(uid)":"notified"])
                        createMeetingNotification(meeting: meeting, attendee_id: uid, date: datetime_start)
                    }
                }
            })
        }
    }
    
    
    // MARK: - trigger a meeting invitation notification immedietly
    func createMeetingNotification(meeting: Meeting, attendee_id: String, date: Int){
        let center = UNUserNotificationCenter.current()
        /// notifications content
        let content = UNMutableNotificationContent()
        content.title = "Meeting Invitation"
        content.body =  "You are invited to \(meeting.title). At \(meeting.datetime_start.formatted(date: .complete, time: .omitted))"
        content.sound = .default
        content.categoryIdentifier = "INVITE_ACTION"
        content.userInfo = ["attendee_id": attendee_id, "host_id": meeting.host, "meeting_id": meeting.id, "date": date, "title": meeting.title]
        
        /// setup the 2 actions, accept and reject
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
        let request = UNNotificationRequest(identifier: notification_id, content: content, trigger: nil) /// immediately notify
        
        center.add(request) { error in
            if error == nil{
                print("invitation notification triggered")
            }
        }
    }
    
    
    // MARK: - trigger a notification five minutes before the meeting
    func scheduleMeetingReminder(title: String, date: Int){
        let date: Date = .init(timeIntervalSince1970: TimeInterval(date - (5 * 60))) /// subtract 5 minutes from the date
        let center = UNUserNotificationCenter.current()
        
        /// setup the notification content
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Meeting Reminder"
        content.body = "Your meeting - \(title). Is in five minutes!"
        
        /// convert to the correct timzone then to a date component  - this could be a simulator problem though!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let uuid = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false) /// trigger based on a specific date
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request) { error in
            if error == nil{
                print("reminder notification triggered at \(components)")
            }
        }
    }
}
