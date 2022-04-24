//
//  viewMyleaves.swift
//  Checkly
//
//  Created by Norua Alsalem on 22/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct viewMyLeaves: View {
    
    @ObservedObject var vm = viewMyLeavesViewModel()
    
    
    var body: some View {
    
        
        ScrollView{
            VStack (spacing: 8){
                ForEach(vm.leaves) { leave in
                    
                    
            HStack{
                VStack (alignment: .leading){
            Text("Your \(leave.type) Request")
                    HStack{
            HStack {
                Text(leave.start_date)
                Image(systemName: "arrow.right").foregroundColor(Color(red: 0.173, green: 0.686, blue: 0.933))
                Text(leave.end_date)
                    
                }
                
                Spacer()
                //red
                if ( leave.status == "rejected" ) {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.306)).opacity(0.2).overlay(
                    Text(leave.status)).foregroundColor(Color(red: 0.902, green: 0.306, blue: 0.30))
                }
                //green
                else if ( leave.status == "accepted" )  {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604)).opacity(0.2).overlay(
                    Text(leave.status)).foregroundColor(Color(red: 0.306, green: 0.902, blue: 0.604))
                }
                //yellow
                else {
                RoundedRectangle(cornerRadius: 20).frame(width: 90, height: 30).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408)).opacity(0.2).overlay(
                    Text(leave.status)).foregroundColor(Color(red: 0.969, green: 0.675, blue: 0.408))
                }
                    }
            }.padding().frame(width: 350, height: 100).background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
            
            }
            }
            }.padding()
        }.padding().navigationBarTitle("My Leaves Status").navigationBarTitleDisplayMode(.inline)
        
    }
}

class viewMyLeavesViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    @Published var leaves = [Leave]()
    
    init () {
        getMyLeaves()
    }

    
    func getMyLeaves(){
            
        ref.child("Leave").observe(.value, with: { dataSnapshot in
            self.leaves = []
        for lev in dataSnapshot.children {
        let obj = lev as! DataSnapshot

        let start_date = obj.childSnapshot(forPath: "start_date").value as! String
        let end_date = obj.childSnapshot(forPath: "end_date").value as! String
        let status = obj.childSnapshot(forPath: "status").value as! String
        let notes = obj.childSnapshot(forPath: "notes").value as! String
        let type = obj.childSnapshot(forPath: "type").value as! String
        let employee_id = obj.childSnapshot(forPath: "emp_id").value as! String
            
            if ( employee_id == self.user!.uid) {
                let leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: UUID().uuidString, type: type, employee_id: "", employee_name: "", photoURL: "")
        
                self.leaves.append(leave)
            }
            
            
        }
            
    }
)
        print(self.leaves)
    }
    
    
}


struct viewMyLeaves_Previews: PreviewProvider {
    static var previews: some View {
        viewMyLeaves()
    }
}
