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
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    
                
        ForEach (vm.leaves,  id: \.self) { leave in
            
            
            HStack (spacing: 10){
                Text(leave.type)
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
                
            
                let Leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: UUID().uuidString, type: type, employee_id: emp_id, employee_name: "", employee_department: "")
                
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

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
