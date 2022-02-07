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
    }
    
    // REALTIME
    func getMeetings(){
        
        let ref = Database.database().reference()
        
        DispatchQueue.main.async {
            ref.child("Meetings").observe(.childAdded) { snapshot in
                let meeting = snapshot.value as! [String: Any]
                let agenda = meeting["agenda"] as! String
                let attendees = meeting["attendees"] as! String
                let datetime = meeting["datetime"] as! Int
                let host = meeting["host"] as! String
                let location = meeting["location"] as! String
                let meeting_id = meeting["meeting_id"] as! String
                let title = meeting["title"] as! String
                let type = meeting["type"] as! String
        
        
                let mt = Meeting(id: meeting_id, host: host, title: title, dateTime: .init(timeIntervalSince1970: TimeInterval(datetime)), type: type, location: location, attendees: attendees, agenda: agenda)
        
                print(mt)
                // MARK: need to be modified later on to get all the meetings that the user have created, or have been invited to...
                if(mt.host == "1111"){
                    self.meetings.append(mt)
                }
                
                let calendar = NSCalendar.current
        
                let filtered = self.meetings.filter {
                    return calendar.isDate($0.dateTime, inSameDayAs: self.currentDate)
                }
                        .sorted { meeting1, meeting2 in
                                return meeting1.dateTime < meeting2.dateTime
                        }
                        DispatchQueue.main.async {
                            withAnimation {
                                self.filteredMeetings = filtered
                        }
                    }
            }
        }
    }
    
    func filterTodayMeetings(){
       

        let calendar = NSCalendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        let filtered = self.meetings.filter {
            return calendar.isDate($0.dateTime, inSameDayAs: self.currentDate)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.dateTime < meeting2.dateTime
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
            return calendar.isDate($0.dateTime, inSameDayAs: date)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.dateTime < meeting2.dateTime
            }
        
        return filtered
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
        
        (0...14) .forEach { day in
            
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

// FIRESTORE
//    func getMeetings(){
//
//
//        // FIRESTORE
//        let db = Firestore.firestore()
//        db.collection("meetings").getDocuments { snapshot, error in
//
//            // check for errors
//            if error == nil {
//                // no errors
//                if let snapshot = snapshot {
//                    // get all docs (should check whether the current user match the host id or available in the attendees array)
//
//                    DispatchQueue.main.async {
//                        self.meetings = snapshot.documents.map { d in
//                            // create meeting object for each doc returned
//                            return Meeting(id: d.documentID,
//                                           meeting_id: d["meeting_id"] as? String ?? "",
//                                           host: d["host"] as? String ?? "",
//                                           title: d["title"] as? String ?? "",
//                                           dateTime: (d["dateTime"] as? Timestamp)?.dateValue() ?? Date(),
//                                           type: d["type"] as? String ?? "",
//                                           location: d["location"] as? String ?? "",
//                                           attendees: d["attendees"] as? String ?? "",
//                                           agenda: d["agenda"] as? String ?? "")
//
//                        }
//                        print("inside fetching")
//                        // filter meeting
//                        let calendar = Calendar.current
//
//                        let filtered = self.meetings.filter {
//                            return calendar.isDate($0.dateTime, inSameDayAs: self.currentDate)
//                        }
//
//                            .sorted { meeting1, meeting2 in
////                                return meeting1.dateTime > meeting2.dateTime
//                                return meeting1.dateTime < meeting2.dateTime
//                            }
//
//                        DispatchQueue.main.async {
//                            withAnimation {
//                                self.filteredMeetings = filtered
//                             }
//                            }
//                    }
//                }
//
//            } else {
//                // handle errors
//                print("error")
//            }
//
//        }
//
//    }
