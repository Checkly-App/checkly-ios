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
    @State var selectedStatus: String?
    let statues: [String] = ["On time",
                            "Late",
                            "Absent"]
    
    var body: some View {
                
        // Date Pickers
        VStack {
        DatePicker("From Date", selection: $fromDate, in: ...Date() , displayedComponents: .date).padding()
        
        DatePicker("To Date", selection: $toDate, in: ...Date() , displayedComponents: .date).padding()
        // statues filter
            HStack {
                ForEach(statues, id:  \.description) { status in
                    CheckBox(selectedStatus: self.$selectedStatus, status: status)
                }
            }
        // Search Button
            Text("Search").onTapGesture {
                vm.returnDatesInRange(fromDate: fromDate, toDate: toDate)
                vm.filteredAttendancesDates.removeAll()
            }
                Text(selectedStatus ?? "On time")
            ForEach (vm.filteredAttendancesDates, id: \.self) { attendance in
            HStack {
                VStack{
                    Text("Date")
                    Text(attendance.date)
                }
                VStack{
                    Text("Check In")
                    Text(attendance.checkIn)
                }.padding()
                VStack{
                    Text("Check Out")
                    Text(attendance.checkOut)
                }.padding()
            }.padding()
            }
        }
    }
}


class attendanceHistoryViewModel: ObservableObject {
    
    @Published var attendances = [attendance]()
    @Published var filteredAttendances = [attendance]()
    @Published var filteredAttendancesDates = [attendance]()
    
    init () {
        fetchAttendances()
    }

    func fetchAttendances () {
    
    let ref = Database.database().reference()
    let searchQueue = DispatchQueue.init(label: "searchQueue")
    let empID = "8UoUAkIZvnP5KSWHydWliuZmOKt2" //change
        
    searchQueue.sync {
        
        ref.child("LocationAttendance/emp\(empID)-Attendance").observe(.value, with: { dataSnapshot in

            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                let obj = snap.value as! [String: Any]
                let checkIn = obj["check-in"] as! String
                let checkOut = obj["check-out"] as! String
                let status = obj["status"] as! String
                let workingHours = obj["working-hours"] as! String
                let date = snap.key
            
                let attendance = attendance(id: empID, date: date, checkIn: checkIn, checkOut: checkOut, status: status, workingHours: workingHours)
                
                    self.attendances.append(attendance)
            }
        })
    }
    
}
    func fetchFilteredAttendances () {
        
    }
    
    
    func returnDatesInRange (fromDate: Date, toDate: Date) {
        
    let ref = Database.database().reference()
    let searchQueue = DispatchQueue.init(label: "searchQueue")
    let empID = "8UoUAkIZvnP5KSWHydWliuZmOKt2" //change
    let range = fromDate...toDate
        
    searchQueue.sync {
        
        ref.child("LocationAttendance/emp\(empID)-Attendance").observe(.value, with: { dataSnapshot in

            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                let obj = snap.value as! [String: Any]
                let checkIn = obj["check-in"] as! String
                let checkOut = obj["check-out"] as! String
                let status = obj["status"] as! String
                let workingHours = obj["working-hours"] as! String
                let date = snap.key
            
                let attendance = attendance(id: empID, date: date, checkIn: checkIn, checkOut: checkOut, status: status, workingHours: workingHours)
                    let formattedDate = convertDateToObject(Date: attendance.date)
                    if range.contains(formattedDate) {
                        self.filteredAttendancesDates.append(attendance)
                    } else {
                        print("The date is outside the range")
                    }
            }
        })
    }
}
}

    func convertDateToObject (Date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: Date)
        return date!
    }

struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        attendanceHistoryView()
    }
}
    
    struct CheckBox: View {

        @Binding var selectedStatus: String?
        var status: String

        var body: some View {
            Button(action: { self.selectedStatus = self.status }) {
                VStack{
                    Text(status).foregroundColor(.black)
                }.frame(width: 100, height: 100).background(Color(.green))
            }
    }
}




