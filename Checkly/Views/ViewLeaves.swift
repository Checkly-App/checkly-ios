//
//  ViewLeaves.swift
//  Checkly
//
//  Created by Norua Alsalem on 25/03/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ViewLeaves: View {
    
    @ObservedObject var vm = ViewLeaveViewModel()
    @State private var showingSheet = false
    @State var selectedLeave = Leave(start_date: "" , end_date: "", status: "", notes: "", document: "", id: "", type: "", employee_id: "", employee_name: "")
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack (spacing: 30){
                    
                
        ForEach (vm.leaves,  id: \.self) { leave in
            
            
            HStack {
                
                VStack {
                    HStack {
                    VStack (alignment: .leading) {
                    Text("From \(leave.employee_name)").fontWeight(.bold)
                    Text(leave.type).foregroundColor(.gray)
                    }
                        Spacer()
                        if ( leave.status == "rejected" ) {
                        RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.306)).opacity(0.2).overlay(
                            Text(leave.status)).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.30))
                        } else if ( leave.status == "accepted" )  {
                        RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604)).opacity(0.2).overlay(
                            Text(leave.status)).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604))
                        } else {
                        RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408)).opacity(0.2).overlay(
                            Text(leave.status)).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408))
                        }
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40).foregroundColor(.gray).opacity(0.2).overlay(
                            Text(leave.start_date)
                    )
                        Image(systemName: "arrow.right").foregroundColor(Color(red: 0.173, green: 0.686, blue: 0.933))
                        
                        RoundedRectangle(cornerRadius: 10).frame(width: 100, height:    40).foregroundColor(.gray).opacity(0.2).overlay(
                            Text(leave.end_date)
                )
                    }
                }
                Spacer()

                
            }.contentShape(Rectangle())
                .onTapGesture {
                    selectedLeave = leave
                    showingSheet.toggle()
                }.sheet(isPresented: $showingSheet) {
                    SheetView(leave: $selectedLeave)
                }.padding().frame(width: 350, height: 150).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
             
            
            }
                    
                    
        
                }.padding()
            }.navigationTitle("Leave Requests").navigationBarTitleDisplayMode(.inline)
}
}
    
}

class ViewLeaveViewModel: ObservableObject {
    
    //auth
    let manager_id = "PIfzRqUP9FdUf8cAr1UKHmxtEK12"
    
    @Published var emp = Employee(employee_id: "", address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number: "", position: "", photoURL: "")
    
    @Published var leaves = [Leave]()

    
    init() {
        fetchLeaves()
    }
    

    
    func fetchLeaves () {
        
        let ref = Database.database().reference()
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
        searchQueue.sync {
            
            ref.child("Leave").observe(.childAdded) { snapshot in
                
                let obj = snapshot.value as! [String: Any]
                let start_date = obj["start_date"] as! String
                let end_date = obj["end_date"] as! String
                let status = obj["status"] as! String
                let type = obj["type"] as! String
                let notes = obj["notes"] as! String
                let emp_id = obj["emp_id"] as! String
                let manager = obj["manager_id"] as! String
                let employee_name = obj["employee_name"] as! String
                let leave_id = obj["leave_id"] as! String
                
                let leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: leave_id, type: type, employee_id: emp_id, employee_name: employee_name)
                
                if ( manager == self.manager_id ) {
                        self.leaves.append(leave)
                }
            }
        }
    }
}

struct ViewLeaves_Previews: PreviewProvider {
    static var previews: some View {
        ViewLeaves()
    }
}

struct SheetView: View {
    
    @Binding var leave: Leave
    @Environment(\.dismiss) var dismiss
    @State private var showingAcceptAlert = false
    @State private var showingRejectAlert = false
    let ref = Database.database().reference()

    var body: some View {
        
        if ( leave.status == "pending") {
        
            VStack {
                
                VStack (alignment: .center, spacing: 30) {
                    
                    VStack (spacing: 1) {
                    Text("From \(leave.employee_name)").fontWeight(.bold).font(.system(size: 25))
                    
                        Text(leave.type).foregroundColor(.gray).fontWeight(.light).font(.system(size: 20))
                    }
                    RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408)).opacity(0.2).overlay(
                        Text(leave.status)).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40).foregroundColor(.gray).opacity(0.2).overlay(
                            Text(leave.start_date)
                    )
                        Image(systemName: "arrow.right").foregroundColor(Color(red: 0.173, green: 0.686, blue: 0.933))
                        
                        RoundedRectangle(cornerRadius: 10).frame(width: 100, height:    40).foregroundColor(.gray).opacity(0.2).overlay(
                            Text(leave.end_date)
                )
                    }
                    
                    HStack{
                        if (leave.notes == " " || leave.notes == "Any additional notes?") {
                          Text("No notes attached")
                        } else {
                            Text(leave.notes)
                        }
                    }.frame(width: 300, height: 80)
                        .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1))
                    )
                    HStack{
                        Text("No documents attached")
                    }.frame(width: 300, height: 80)
                        .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1))
                    )
                    


                }.padding()
                Spacer()
                HStack (spacing: 40){
            RoundedRectangle(cornerRadius: 10).frame(width: 120, height:    50).foregroundColor(.gray).opacity(0.2).overlay(
                Button("Accept") {
                    showingAcceptAlert = true
                }.alert("Are you sure you want to accept this leave request?", isPresented: $showingAcceptAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        
                        findLeave(leaveID: leave.id, newStatuss: "accepted")
                    }
                }
            )
            
            RoundedRectangle(cornerRadius: 10).frame(width: 120, height:    50).foregroundColor(.gray).opacity(0.2).overlay(
                Button("Reject") {
                    showingRejectAlert = true
                }.alert("Are you sure you want to reject this leave request?", isPresented: $showingRejectAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        
                        findLeave(leaveID: leave.id, newStatuss: "rejected")
                    }
                }
            )
                }.padding()
            }.padding()
        } else {
            Text("This leave has already been \(leave.status)")
        }
    }
}

func findLeave (leaveID: String, newStatuss: String) {
    
    let ref = Database.database().reference()
    let searchQueue = DispatchQueue.init(label: "searchQueue")
    
    searchQueue.sync {
        
        ref.child("Leave").observe(.childAdded) { snapshot in
            
            let obj = snapshot.value as! [String: Any]
            let start_date = obj["start_date"] as! String
            let end_date = obj["end_date"] as! String
            let status = obj["status"] as! String
            let type = obj["type"] as! String
            let notes = obj["notes"] as! String
            let emp_id = obj["emp_id"] as! String
            let employee_name = obj["employee_name"] as! String
            let leave_id = obj["leave_id"] as! String
            
            let leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: leave_id, type: type, employee_id: emp_id, employee_name: employee_name)
            
            if ( leave.id == leaveID ) {
                setStatus(key: snapshot.key, newStatuss: newStatuss)
            }
        }
    }
}

func setStatus (key: String, newStatuss: String) {
    
    Database.database().reference().root.child("Leave").child(key).updateChildValues(["status": newStatuss])
    
}

