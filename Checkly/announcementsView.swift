//
//  announcementsView.swift
//  Checkly
//
//  Created by Norua Alsalem on 20/04/2022.
//
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct announcementsView: View {
    
    @ObservedObject var vm = announcementsViewViewModel()
    
    
    var body: some View {
    
        
        ScrollView{
            VStack (spacing: 8){
                ForEach(vm.announcements) { announcement in
                    
            HStack{
                VStack (alignment: .leading) {
                Text(announcement.title)
                Text(announcement.department).font(.caption).foregroundColor(.gray)
                }
                
                Spacer()

            }.padding().frame(width: 350, height: 50).background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
            
        
            }
            }.padding()
        }.padding().navigationBarTitle("Employees' Attendance Status").navigationBarTitleDisplayMode(.inline)
        
    }
}

class announcementsViewViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    @Published var announcements = [Announcement]()
    
    init () {
        getDepartmentAnnouncements(dep: "String")
//        fetchDepartment()
    }
    
    func fetchDepartment() {


        let searchQueue = DispatchQueue.init(label: "searchQueue")

        searchQueue.sync {

            ref.child("Employee").observe(.value, with: { dataSnapshot in
                
            for emp in dataSnapshot.children {
            let obj = emp as! DataSnapshot

            let department = obj.childSnapshot(forPath: "departmennt").value as! String
            let employee_id = obj.childSnapshot(forPath: "employee_id").value as! String

                
                if ( employee_id == "FJvmCdXGd7UWELDQIEJS3kisTa03") {
                    self.getDepartmentAnnouncements(dep: department)
                }
            
            }
                
            }
                                          )}
                                          }
    

    
    func getDepartmentAnnouncements(dep: String){
        
        if (!(self.announcements.isEmpty)) {
            self.announcements = []
        }
        else if (self.announcements.isEmpty) {
            
        ref.child("Announcement").observe(.value, with: { dataSnapshot in
            self.announcements = []
        for announcement in dataSnapshot.children {
        let obj = announcement as! DataSnapshot

        let title = obj.childSnapshot(forPath: "title").value as! String
        let body = obj.childSnapshot(forPath: "body").value as! String
        let department = obj.childSnapshot(forPath: "department").value as! String
//        let timestamp = Date()
            
            if ( department == "dep_5") {
                let announcement = Announcement(id: UUID().uuidString, body: body, title: title, department: department, date: "Date()")
        
            self.announcements.append(announcement)
            }
        }
             print("XXXXXXXXXXXXXXXXXXX")
            print(self.announcements)
            
            }, withCancel: { error in
            print(error.localizedDescription)
            })
        }
    }
}

struct announcementsView_Previews: PreviewProvider {
    static var previews: some View {
        announcementsView()
    }
}

