//
//  MeetingViewModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class MeetingViewModel: ObservableObject{
   
    @Published var meetings = [Meeting]()
    
    @Published var selectedMeeting: Meeting?
    
    @Published var attendeesList = [attendee]()

    // current week days
    @Published var currentWeek: [Date] = []

    // current day
    @Published var currentDate: Date = Date()

    // filter meetings based on selected date
    @Published var filteredMeetings: [Meeting]?
    
    // Variables
    private var ref = Database.database().reference()
    private var calendar = NSCalendar.current
    private var userID = Auth.auth().currentUser?.uid
    
    
    // initializing
    init(){
        fetchCurrentWeek()
        getMeetings()
        fillAttendeesList()
    }
    
    // REALTIME
    func getMeetings(){
        
        DispatchQueue.main.async {
            self.ref.child("Meetings").observe(.childAdded) { snapshot in
                let meeting = snapshot.value as! [String: Any]
                let agenda = meeting["agenda"] as! String
                let attendees = meeting["attendees"] as! [String:String]
                let datetime_end = meeting["datetime_end"] as! Int
                let datetime_start = meeting["datetime_start"] as! Int
                let host = meeting["host"] as! String
                let latitude = meeting["latitude"] as! String
                let location = meeting["location"] as! String
                let longitude = meeting["longitude"] as! String
                let title = meeting["title"] as! String
                let type = meeting["type"] as! String
                let meeting_id = snapshot.key
        
                let mt = Meeting(id: meeting_id, host: host, title: title, datetime_start: .init(timeIntervalSince1970: TimeInterval(datetime_start)), datetime_end: .init(timeIntervalSince1970: TimeInterval(datetime_end)), type: type, location: location, attendees: attendees, agenda: agenda, latitude: latitude, longitude: longitude)
        
                // MARK: Fetch UID from Auth
                if(mt.host == self.userID){
                    self.meetings.append(mt)
                }
                for attendant in mt.attendees {
                    if self.userID == attendant.key {
                        if "accepted" == attendant.value{
                            self.meetings.append(mt)
                        }
                    }
                }
                
        
                let filtered = self.meetings.filter {
                    return self.calendar.isDate($0.datetime_start, inSameDayAs: self.currentDate)
                }
                        .sorted { meeting1, meeting2 in
                                return meeting1.datetime_start < meeting2.datetime_start
                        }
                        DispatchQueue.main.async {
                            withAnimation {
                                self.filteredMeetings = filtered
                        }
                    }
            }
        }
    }
    
    func fillAttendeesList(){
        
            ref.child("Employee").observe(.value) { snapshot in
                for employee in snapshot.children{
                    let obj = employee as! DataSnapshot
                    let uID = obj.key
                    let name = obj.childSnapshot(forPath:  "name").value as! String
                    let position = obj.childSnapshot(forPath: "position").value as! String
                    let imgToken = obj.childSnapshot(forPath: "image_token").value as! String
                    let employee = attendee(id: uID, name: name, position: position ,imgToken: imgToken, status: "")
                    self.attendeesList.append(employee)
                }
            }
    }
    
    func getHostName(hostID: String) -> String {
        
        var hostName = ""
        for host in attendeesList{
            if host.id == hostID {
                hostName = host.name
            }
        }
        return hostName
    }
    
    func filterTodayMeetings(){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        let filtered = self.meetings.filter {
            return self.calendar.isDate($0.datetime_start, inSameDayAs: self.currentDate)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.datetime_start < meeting2.datetime_start
            }
        
        DispatchQueue.main.async {
            withAnimation {
                self.filteredMeetings = filtered
             }
            }
        }
    }
    func filteredMeetingsArray(date: Date) -> [Meeting]? {
       
        var filtered = [Meeting]()
            
        filtered = self.meetings.filter {
            return calendar.isDate($0.datetime_start, inSameDayAs: date)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.datetime_start < meeting2.datetime_start
            }
        
        return filtered
    }
    
    func meetingAttendeesArray(meeting: Meeting) -> [attendee] {
        
        var attendeesArray = [attendee]()
        
        // if current user is the host if the meetings fetch all attendees regardless of their status
        if isHost(meeting: meeting){
            if meeting.attendees.count != 0 {
                for attendant in meeting.attendees{
                    for employee in attendeesList {
                        if attendant.key == employee.id {
                            let employee = attendee(id: employee.id, name: employee.name, position: employee.position ,imgToken: employee.imgToken, status: attendant.value)
                            attendeesArray.append(employee)
                        }
                    }
                }
            }
        }
        else if meeting.attendees.count != 0 {
            for attendant in meeting.attendees{
                if attendant.value == "accepted" {
                    for employee in attendeesList {
                        if attendant.key == employee.id {
                            let employee = attendee(id: employee.id, name: employee.name, position: employee.position ,imgToken: employee.imgToken, status: attendant.value)
                            attendeesArray.append(employee)
                        }
                    }
                }
            }
        } else {
            attendeesArray = []
        }
        return attendeesArray
    }
    
    func isHost(meeting: Meeting)-> Bool{
        
        // check if current user is the host
        if meeting.host == userID {
            return true
        }
        
//        if meeting.host == "olU8zzFyDhN2cn4IxJKyIuXT5hM2" {
//            return true
//        }
        
        return false
    }
    
    func takeMeetingAttendance(meeting_id: String, attendeesDictionary: [String:String]){
        
        ref.child("Meetings").child(meeting_id).child("attendees").updateChildValues(attendeesDictionary)
        
    }
    
    func meetingAttendanceTaken(meeting: Meeting) -> Bool {
        
        for attendee in meeting.attendees{
            if attendee.value == "attended" || attendee.value == "absent" {
                return true
            }
        }
        return false
    }
    
    // Fetch current week days from Sun to Sat
    func fetchCurrentWeek(){
        
        let today = Date()
        
        calendar.firstWeekday = 7
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
    
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0...7) .forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
            
        }
    }
    
    // Extracting date
    func extractDate(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }

    // Check if current date is today's date
    func isToday(date: Date) -> Bool{
        
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
}

struct attendee: Identifiable, Hashable{
    var id: String
    var name: String
    var position: String
    var imgToken: String
    var status: String
}
