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
                VStack {
                    
                
        ForEach (vm.leaves,  id: \.self) { leave in
            
            
            HStack (spacing: 10){
                Text(leave.type)
            }.contentShape(Rectangle())
                .onTapGesture {
                    selectedLeave = leave
                    showingSheet.toggle()
                }.sheet(isPresented: $showingSheet) {
                    SheetView(leave: $selectedLeave)
            }.padding()
                .background(Color.white)

                .clipped()
                .shadow(color: Color.gray, radius: 3, x: 1, y: 1)
             
            
            }
                    
                    
        
}
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
        
        ref.child("Leave").observe(.value, with: { dataSnapshot in

            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                let obj = snap.value as! [String: Any]
                let start_date = obj["start_date"] as! String
                let end_date = obj["end_date"] as! String
                let status = obj["status"] as! String
                let type = obj["type"] as! String
                let notes = obj["notes"] as! String
                let emp_id = obj["emp_id"] as! String
                let manager = obj["manager_id"] as! String
                let employee_name = obj["employee_name"] as! String
                
            
                let Leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: UUID().uuidString, type: type, employee_id: emp_id, employee_name: employee_name)
                
                if ( manager == self.manager_id ) {
                    self.leaves.append(Leave)
                }
            }
        })
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
    @State private var showingAlert = false
    let ref = Database.database().reference()

    var body: some View {
        
        
        Text(leave.start_date)
        HStack{
            Button("Accept") {
                showingAlert = true
            }
            .alert("Are you sure you want to accept the leave request?", isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Yes") {
                
                }
            }
        Button {
            
        } label: {
            Text("Reject")
        }
        }

        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

func changeStatus () {
    
    let ref = Database.database().reference()

    let Leave: [String: Any] = [
        "status": "pending"
    ]

    ref.child("Leave").childByAutoId().setValue(Leave)
    
}

