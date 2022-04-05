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
        
        ScrollView{
        ForEach(vm.employees , id: \.self) { emp in
            VStack{
            HStack{
                Text(emp.name)
                Text(emp.status)
            
        }.padding().frame(width: 350, height: 50).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
            }.padding()
        }
        }.padding()
    

//                HStack {
//                    Spacer()
//                    if ( leave.status == "rejected" ) {
//                    RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.306)).opacity(0.2).overlay(
//                        Text(leave.status)).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.30))
//                    } else if ( leave.status == "accepted" )  {
//                    RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604)).opacity(0.2).overlay(
//                        Text(leave.status)).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604))
//                    } else {
//                    RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408)).opacity(0.2).overlay(
//                        Text(leave.status)).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408))
//                    }
//                }
            
        
    }
}

class viewEmployeesAttendanceStatusViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    var department = ""
    @Published var employees = [list]()
    
    init () {
        fetchDepartment()
    }
    
    func fetchDepartment() {
        
        
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
        searchQueue.sync {
            
            ref.child("Department").observe(.childAdded) { snapshot in
                
                let obj = snapshot.value as! [String: Any]
                let manager_id = obj["manager"] as! String
                
                if ( manager_id == self.user!.uid ) {
                    self.getCompanyEmployees(dep: snapshot.key)
                }
            }
        }
        print(self.department)
        
    }
    
    func getCompanyEmployees(dep: String){

        let Queue = DispatchQueue.init(label: "Queue")
        

        Queue.sync {

        ref.child("Employee").observe(.value, with: { dataSnapshot in
        for emp in dataSnapshot.children {
        let obj = emp as! DataSnapshot

        let name = obj.childSnapshot(forPath: "name").value as! String
        let department = obj.childSnapshot(forPath: "department").value as! String
        let status  = obj.childSnapshot(forPath: "status").value as! String
            
            if ( department == dep) {
            let list = list(name: name, status: status)
        
            self.employees.append(list)
            }

                }
            }, withCancel: { error in
            print(error.localizedDescription)
            })
        }
    }
}


struct list: Hashable {
    var name: String
    var status: String
}

struct viewEmployeesAttendanceStatus_Previews: PreviewProvider {
    static var previews: some View {
        viewEmployeesAttendanceStatus()
    }
}
