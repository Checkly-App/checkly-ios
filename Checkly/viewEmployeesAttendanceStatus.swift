//
//  viewEmployeesAttendanceStatus.swift
//  Checkly
//
//  Created by Norua Alsalem on 22/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct viewEmployeesAttendanceStatus: View {
    
    @ObservedObject var vm = viewEmployeesAttendanceStatusViewModel()
    
    
    var body: some View {
    
        
        ScrollView{
            VStack (spacing: 8){
                ForEach(vm.employees) { emp in
                    
            HStack{
                VStack (alignment: .leading) {
                Text(emp.name)
                Text(emp.department).font(.caption).foregroundColor(.gray)
                }
                
                Spacer()
                //red
                if ( emp.status == "Late" ) {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.306)).opacity(0.2).overlay(
                    Text(emp.status)).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.30))
                }
                //green
                else if ( emp.status == "Early" )  {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604)).opacity(0.2).overlay(
                    Text(emp.status)).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604))
                }
                //yellow
                else {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.333, green: 0.667, blue: 0.984)).opacity(0.2).overlay(
                    Text("-")).foregroundColor(Color(red: 0.333, green: 0.667, blue: 0.984))
                }
            }.padding().frame(width: 350, height: 50).background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
            
        
            }
            }.padding()
        }.padding().navigationBarTitle("Employees' Attendance Status").navigationBarTitleDisplayMode(.inline)
        
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
    }

    
    func getCompanyEmployees(dep: String){
        
        print(self.employees.isEmpty)
        if (!(self.employees.isEmpty)) {
            self.employees = []
        }
        else if (self.employees.isEmpty) {
            
        ref.child("Employee").observe(.value, with: { dataSnapshot in
            self.employees = []
        for emp in dataSnapshot.children {
        let obj = emp as! DataSnapshot

        let name = obj.childSnapshot(forPath: "name").value as! String
        let department = obj.childSnapshot(forPath: "department").value as! String
        let status  = obj.childSnapshot(forPath: "status").value as! String
            
            if ( department == dep) {
                let list = list(id: UUID().uuidString , name: name, status: status, department: department)
        
            self.employees.append(list)
            }
        }
                
            print(self.employees)
            
            }, withCancel: { error in
            print(error.localizedDescription)
            })
        }
    }
}


struct list: Hashable, Identifiable {
    var id: String
    var name: String
    var status: String
    var department: String
}

struct viewEmployeesAttendanceStatus_Previews: PreviewProvider {
    static var previews: some View {
        viewEmployeesAttendanceStatus()
    }
}
