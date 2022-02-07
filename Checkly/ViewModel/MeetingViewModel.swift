//
//  MeetingViewModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import FirebaseFirestore

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
//        filterTodayMeetings()
    }
    // fetch meetings
    func getMeetings(){
        
        
        // FIRESTORE
        let db = Firestore.firestore()
        db.collection("meetings").getDocuments { snapshot, error in

            // check for errors
            if error == nil {
                // no errors
                if let snapshot = snapshot {
                    // get all docs (should check whether the current user match the host id or available in the attendees array)

                    DispatchQueue.main.async {
                        self.meetings = snapshot.documents.map { d in
                            // create meeting object for each doc returned
                            return Meeting(id: d.documentID,
                                           meeting_id: d["meeting_id"] as? String ?? "",
                                           host: d["host"] as? String ?? "",
                                           title: d["title"] as? String ?? "",
                                           dateTime: (d["dateTime"] as? Timestamp)?.dateValue() ?? Date(),
                                           type: d["type"] as? String ?? "",
                                           location: d["location"] as? String ?? "",
                                           attendees: d["attendees"] as? String ?? "",
                                           agenda: d["agenda"] as? String ?? "")

                        }
                        print("inside fetching")
                        // filter meeting
                        
                        let calendar = NSCalendar.current

                        let filtered = self.meetings.filter {
                            return calendar.isDate($0.dateTime, inSameDayAs: self.currentDate)
                        }

                            .sorted { meeting1, meeting2 in
//                                return meeting1.dateTime > meeting2.dateTime
                                return meeting1.dateTime < meeting2.dateTime
                            }

                        DispatchQueue.main.async {
                            withAnimation {
                                self.filteredMeetings = filtered
                             }
                            }
                    }
                }

            } else {
                // handle errors
                print("error")
            }

        }
        
    }
    
    func filterTodayMeetings(){
       
        getMeetings()

        let calendar = NSCalendar.current
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        let filtered = self.meetings.filter {
            return calendar.isDate($0.dateTime, inSameDayAs: self.currentDate)
//            return calendar.isDate($0.date, inSameDayAs: self.currentDate)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.dateTime < meeting2.dateTime
//                return meeting1.date < meeting2.date
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
//            return calendar.isDate($0.date, inSameDayAs: self.currentDate)
        }
        
            .sorted { meeting1, meeting2 in
                return meeting1.dateTime < meeting2.dateTime
//                return meeting1.date < meeting2.date
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
    // String to Date
    func StringToDate(date: String) -> Date {
        // 2022-02-06
        let formatter = DateFormatter()
        
//        formatter.dateFormat = "yyyy-mm-dd"
        
        // if nil return today's date, which is not accepted... need to be modified somehow
        return formatter.date(from: date) ?? Date()
    }
    // MARK: Check if current date is today's date
    func isToday(date: Date) -> Bool{
       
        let calendar = NSCalendar.current
        
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
}

// REALTIME
//let ref = Database.database().reference()
//
//DispatchQueue.main.async {
//    ref.child("Meetings").observe(.childAdded) { snapshot in
//        let meeting = snapshot.value as! [String: Any]
//        let agenda = meeting["agenda"] as! String
//        let attendees = meeting["attendees"] as! String
//        let date = meeting["date"] as! String
//        let time = meeting["time"] as! String
//        let host = meeting["host"] as! String
//        let location = meeting["location"] as! String
//        let meeting_id = meeting["meeting_id"] as! String
//        let title = meeting["title"] as! String
//        let type = meeting["type"] as! String
//
//        // convert before inserting
//        let convertedDate = self.StringToDate(date: date)
//
//        let mt = Meeting(id: meeting_id, host: host, title: title, date: convertedDate, time: time ,type: type, location: location, attendees: attendees, agenda: agenda)
//
//        print(mt)
//
//        if(mt.host == "1234"){
//            self.meetings.append(mt)
//        }
//        let calendar = Calendar.current
//
//        let filtered = self.meetings.filter {
//            return calendar.isDate($0.date, inSameDayAs: self.currentDate)
//        }
//
//                .sorted { meeting1, meeting2 in
//                        return meeting1.date < meeting2.date
//                }
//
//                DispatchQueue.main.async {
//                    withAnimation {
//                        self.filteredMeetings = filtered
//                }
//            }
//    }
//}


