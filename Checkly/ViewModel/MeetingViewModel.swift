//
//  MeetingViewModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import FirebaseDatabase

class MeetingViewModel: ObservableObject{
   
    @Published var meetings = [Meeting]()
    
    @Published var selectedMeeting: Meeting?
    
    @Published var employeesList = [emp]()

    // current week days
    @Published var currentWeek: [Date] = []

    // current day
    @Published var currentDate: Date = Date()

    // filter meetings based on selected date
    @Published var filteredMeetings: [Meeting]?
    
    // initializing
    init(){
        fetchCurrentWeek()
        getMeetings()
        fillEmployeesList()
    }
    
    // REALTIME
    func getMeetings(){
        
        let ref = Database.database().reference()
        
        DispatchQueue.main.async {
            ref.child("Meetings").observe(.childAdded) { snapshot in
                let meeting = snapshot.value as! [String: Any]
                let agenda = meeting["agenda"] as! String
                let attendees = meeting["attendees"] as! [String:String]
                let date = meeting["date"] as! Int
                let end_time = meeting["end_time"] as! String
                let host = meeting["host"] as! String
                let latitude = meeting["latitude"] as! String
                let location = meeting["location"] as! String
                let longitude = meeting["longitude"] as! String
                let start_time = meeting["start_time"] as! String
                let title = meeting["title"] as! String
                let type = meeting["type"] as! String
                let meeting_id = snapshot.key
        
                let mt = Meeting(id: meeting_id, host: host, title: title, date: .init(timeIntervalSince1970: TimeInterval(date)), type: type, location: location, attendees: attendees, agenda: agenda, end_time: end_time, start_time: start_time, latitude: latitude, longitude: longitude)
        
//                print(mt)
                // MARK: Fetch UID from Auth
                if(mt.host == "e0a6ozh4A0QVOXY0tyiMSFyfL163"){
                    self.meetings.append(mt)
                }
                for attendant in mt.attendees {
                    if "e0a6ozh4A0QVOXY0tyiMSFyfL163" == attendant.key {
                        if "accepted" == attendant.value{
                            self.meetings.append(mt)
                        }
                    }
                }
                
                let calendar = NSCalendar.current
        
                let filtered = self.meetings.filter {
                    return calendar.isDate($0.date, inSameDayAs: self.currentDate)
                }
                        .sorted { meeting1, meeting2 in
                                return meeting1.date < meeting2.date
                        }
                        DispatchQueue.main.async {
                            withAnimation {
                                self.filteredMeetings = filtered
                        }
                    }
            }
        }
    }
    
    func fillEmployeesList(){
        
        let ref = Database.database().reference()
            ref.child("Employee").observe(.value) { snapshot in
                for employee in snapshot.children{
                    let obj = employee as! DataSnapshot
                    let uID = obj.key
                    let name = obj.childSnapshot(forPath:  "name").value as! String
                    let position = obj.childSnapshot(forPath: "position").value as! String
                    let imgToken = obj.childSnapshot(forPath: "image_token").value as! String
                    let employee = emp(id: uID, name: name, position: position,imgToken: imgToken)
//                    print(employee)
                    self.employeesList.append(employee)
                }
            }
    }
    
    func getHostName(hostID: String) -> String {
        
        var hostName = ""
        for host in employeesList{
            if host.id == hostID {
                hostName = host.name
            }
        }
        return hostName
    }
    
    func filterTodayMeetings(){
       

        let calendar = NSCalendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        let filtered = self.meetings.filter {
            return calendar.isDate($0.date, inSameDayAs: self.currentDate)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.date < meeting2.date
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
        let calendar = NSCalendar.current
        
            
        filtered = self.meetings.filter {
            return calendar.isDate($0.date, inSameDayAs: date)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.date < meeting2.date
            }
        
        return filtered
    }
    
    func meetingAttendeesArray(meeting: Meeting) -> [emp] {
        
        var attendeesArray = [emp]()
        
        if meeting.attendees.count != 0 {
            for attendant in meeting.attendees{
                if attendant.value == "accepted" {
                    for employee in employeesList {
                        if attendant.key == employee.id {
                            let employee = emp(id: employee.id, name: employee.name, position: employee.position ,imgToken: employee.imgToken)
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
    
    // Fetch current week days from Sun to Sat
    func fetchCurrentWeek(){
        
        let today = Date()
//        let calendar = Calendar.current
        var calendar = NSCalendar.current
//        var calendar = Calendar(identifier: .gregorian)
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
       
        let calendar = NSCalendar.current
        
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
}

struct emp: Identifiable{
    var id: String
    var name: String
    var position: String
    var imgToken: String
}
