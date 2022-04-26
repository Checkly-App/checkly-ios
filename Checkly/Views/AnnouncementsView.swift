//
//  announcementsView.swift
//  Checkly
//
//  Created by Norua Alsalem on 24/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct AnnouncementsView: View {
    
    @ObservedObject var vm = announcementsViewViewModel()
    
    
    var body: some View {
    
        
        ScrollView{
            VStack (alignment: .leading, spacing: 8){
                ForEach(vm.announcements) { announcement in
                    
            HStack{
                
                VStack (alignment: .leading, spacing: 10) {
                    HStack{
                        Text(announcement.title).foregroundColor(Color(red: 0.235, green: 0.706, blue: 1)).font(.title3)
                        Spacer()
                        Text(announcement.date).font(.caption).foregroundColor(.gray)
                    }
                    
                    Text(announcement.body).font(.system(size: 16)).foregroundColor(.black)
                Spacer()
                }
                Spacer()
                

            }.padding().frame(width: 350, height: 150).background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
            
      
            }
            }.padding()
            VStack (alignment: .center) {
                Text("No").font(.system(size: 20, weight: .heavy)).foregroundColor(Color(.gray))
                Text("Announcements are available").font(.system(size: 17)).foregroundColor(.gray)
            }.offset(y: 120)
                .opacity(vm.announcements.count == 0 ? 1 : 0 )
        }.padding().navigationBarTitle("Announcements").navigationBarTitleDisplayMode(.inline)
        
    }
}

class announcementsViewViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    @Published var announcements = [Announcement]()
    
    init () {
//        getDepartmentAnnouncements(dep: "String")
        fetchDepartment()
    }
    
    func fetchDepartment() {


        let searchQueue = DispatchQueue.init(label: "searchQueue")

        searchQueue.sync {

            ref.child("Employee/\(user!.uid)").observe(.value, with: { dataSnapshot in
                
            let obj = dataSnapshot.value as! [String:Any]
                
            let department = obj["department"] as! String

            self.getDepartmentAnnouncements(dep: department)
                
            
            
                
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
        let date = obj.childSnapshot(forPath: "date").value as! String
            
            if ( department == dep) {
                let announcement = Announcement(id: UUID().uuidString, body: body, title: title, department: department, date: date)
        
            self.announcements.append(announcement)
            }
        }
            
            
            }, withCancel: { error in
            print(error.localizedDescription)
            })
        }
    }
}

struct announcementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()
    }
}
