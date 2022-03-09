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
    
    var body: some View {
                
        // Date Pickers
        VStack {
            Text("Attendance history").padding(.bottom) // userd as a sub for now
            
            DatePicker("From Date", selection: $fromDate, in: ...Date() , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
        
        DatePicker("To Date", selection: $toDate, in: ...Date() , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
        // statues filter
            HStack {
                Text("CATEGORIES").fontWeight(.bold).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383))
                Spacer()
            }.padding()
            ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                // Late filter
                Button(action: { selectedStatus = "Late" }) {
                    VStack{
                        HStack {
                        Image(systemName: "minus").foregroundColor(.white).padding()
                            Spacer()
                        }
                        Spacer()
                        HStack{
                        Spacer()
                        Text("Late").foregroundColor(.white).fontWeight(.bold).padding()
                        }
                    }.frame(width: 130, height: 100).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.353, green: 0.51, blue: 0.969), Color(red: 0.353, green: 0.51, blue: 0.969).opacity(0.8)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(5).shadow(color: .gray, radius: 4, x: 2, y: 2)
                }.padding(.leading)
                // On time filter
                Button(action: { selectedStatus = "On time" }) {
                    VStack{
                        HStack{
                        Image(systemName: "checkmark").foregroundColor(.white).padding()
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                        Text("On time").foregroundColor(.white).fontWeight(.bold).padding()
                        }
                    }.frame(width: 130, height: 100).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.306, green: 0.902, blue: 0.604), Color(red: 0.306, green: 0.902, blue: 0.604).opacity(0.8)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(5).shadow(color: .gray, radius: 4, x: 2, y: 2)
                    
            }
                // Absent filter
                Button(action: { selectedStatus = "Absent" }) {
                    VStack{
                        HStack{
                        Image(systemName: "xmark").foregroundColor(.white).padding()
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            Text("Absent").foregroundColor(.white).fontWeight(.bold).padding()
                        }
                    }.frame(width: 130, height: 100).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.333, green: 0.667, blue: 0.984), Color(red: 0.333, green: 0.667, blue: 0.984).opacity(0.8)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(5).shadow(color: .gray, radius: 4, x: 2, y: 2)
            }
            }.padding(.bottom)
            }
    
            //results view
            HStack {
                Text("RESULTS").fontWeight(.bold).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383))
                Spacer()
            }.padding()
            ScrollView(.vertical, showsIndicators: false) {
            ForEach (vm.filteredAttendancesDates, id: \.self) { attendance in
                VStack{
            HStack {
                RoundedRectangle(cornerRadius: 20).frame(width: 80, height: 80).foregroundColor(.gray).opacity(0.2).overlay(
                    VStack{
                        let monthName = DateFormatter().monthSymbols[Int(attendance.date[3..<5])! - 1]
                        if ( monthName == "July" || monthName == "June" ) {
                            Text(monthName.uppercased()).font(.system(size: 13)).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).fontWeight(.bold)
                            Text(attendance.date[0..<3]).font(.largeTitle).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383))
                        }
                        Text(monthName[0..<3].uppercased()).font(.system(size: 13)).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).fontWeight(.bold)
                        Text(attendance.date[0..<2]).font(.largeTitle).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383))
                    }
                )
                VStack{
                    Text("Check In").font(.system(size:13))
                    Text(attendance.checkIn).foregroundColor(.gray).fontWeight(.thin)
                }.padding()
                //divider
                Rectangle().fill(Color.gray).frame(width: 0.35, height: 35)
                
                VStack{
                    Text("Check Out").font(.system(size:13))
                    Text(attendance.checkOut).foregroundColor(.gray).fontWeight(.thin)
                }.padding()
                
                Image(uiImage: UIImage(named:"arrow")!).resizable().frame(width: 13, height: 20)
            }.padding().frame(width: 350, height: 100).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
                }.padding(.trailing)
            Spacer()
            }
                
                VStack (alignment: .center) {
                    Text("Oops!").font(.system(size: 20, weight: .heavy)).foregroundColor(Color(.gray))
                    Text("No results matching your filters").font(.system(size: 17)).foregroundColor(.gray)
                }.offset(y: 30)
                    .opacity(vm.filteredAttendancesDates.count == 0 ? 1 : 0 )
        }
            // Search Button
            HStack{
                Text("Search").onTapGesture {
                    vm.fetchFilteredAttendances(fromDate: fromDate, toDate: toDate, selectedStatus: selectedStatus ?? "Not selected")
                    vm.filteredAttendancesDates.removeAll()
                }
            }
        }
    }
}


class attendanceHistoryViewModel: ObservableObject {
    
    @Published var attendances = [attendance]()
    @Published var filteredAttendances = [attendance]()
    @Published var filteredAttendancesDates = [attendance]()
    
    init () {
        
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
    func fetchFilteredAttendances (fromDate: Date, toDate: Date, selectedStatus: String) {
        
    let ref = Database.database().reference()
    let searchQueue = DispatchQueue.init(label: "searchQueue")
    let empID = "8UoUAkIZvnP5KSWHydWliuZmOKt2" //change
    let range = fromDate...toDate
     
        print ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", selectedStatus)
        // did not choose a status filter case
        if ( selectedStatus == "Not selected") {
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
                    
                    if ( range.contains(formattedDate) ){
                        self.filteredAttendancesDates.append(attendance)
                    }
                }
            })
        }
        }
        
        else { searchQueue.sync {
        
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
                
                if ( range.contains(formattedDate) && attendance.status == selectedStatus ) {
                    self.filteredAttendancesDates.append(attendance)
                }
            }
        })
    }
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

    // string extinsion to simplify substringing
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}



