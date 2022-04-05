//
//  viewEmployeesAttendanceStatus.swift
//  Checkly
//
//  Created by Norua Alsalem on 05/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct viewEmployeesAttendanceStatus: View {
    
    @ObservedObject var vm = viewEmployeesAttendanceStatusViewModel()
    
    var body: some View {
        Text(vm.department)
    }
}

class viewEmployeesAttendanceStatusViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    var department = ""
    
    init () {
        fetchDepartment()
    }
    
    func fetchDepartment() {
        
        let ref = Database.database().reference()
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
        searchQueue.sync {
            
            ref.child("Department").observe(.childAdded) { snapshot in
                
                let obj = snapshot.value as! [String: Any]
                let manager_id = obj["manager"] as! String
                
                if ( manager_id == self.user!.uid ) {
                    self.department = snapshot.key
                }
            }
        }
        print(self.department)
    }
    
}

struct viewEmployeesAttendanceStatus_Previews: PreviewProvider {
    static var previews: some View {
        viewEmployeesAttendanceStatus()
    }
}
