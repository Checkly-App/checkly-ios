//
//  attendanceHistoryView.swift
//  Checkly
//
//  Created by Norua Alsalem on 02/03/2022.
//

import SwiftUI
import Firebase

struct attendanceHistoryView: View {
    
    @State var fromDate = Date()
    @State var toDate = Date()
    @ObservedObject var vm = attendanceHistoryViewModel()

    
    var body: some View {
                
        // Date Pickers
        VStack {
        DatePicker("From Date", selection: $fromDate, in: ...Date() , displayedComponents: .date).padding()
        
        DatePicker("To Date", selection: $toDate, in: ...Date() , displayedComponents: .date).padding()
        // Search Button
            Text("Search").onTapGesture {
                vm.fetchFilteredAttendances()
            }
            ForEach (vm.attendances) { attendance in
            HStack {
                VStack{
                    Text("Date")
                    Text(attendance.date)
                }
                VStack{
                    Text("Check In")
                    Text(attendance.time)
                }.padding()
                VStack{
                    Text("Check Out")
                    Text("6:08")
                }.padding()
            }.padding()

        }
        }
    }
}

class attendanceHistoryViewModel: ObservableObject {
    
    @Published var attendances = [attendance]()
    @Published var filteredAttendances = [attendance]()
    
    init () {
        fetchAttendances()
    }

    func fetchAttendances () {
    
    let ref = Database.database().reference()
    let searchQueue = DispatchQueue.init(label: "searchQueue")
    
    searchQueue.sync {
        ref.child("Attendance").observe(.childAdded) { snapshot in
            
            let obj = snapshot.value as! [String: Any]
            let emp_id = obj["employee_id"] as! String
            let date = obj["date"] as! String
            let time = obj["time"] as! String
            let type = obj["type"] as! String

            
            let attendance = attendance(id: emp_id, date: date, time: time, type: type)
            // should be logged-in user ID
            if ( attendance.id == "111111111")  {
                self.attendances.append(attendance)
        }
        }
    }
    
}
    
    func fetchFilteredAttendances () {
        
    }
}


func convertDate (Date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    dateFormatter.string(from: Date)
}

struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        attendanceHistoryView()
    }
}
