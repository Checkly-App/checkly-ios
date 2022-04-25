//
//  servicesView.swift
//  Checkly
//
//  Created by Norua Alsalem on 10/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct servicesView: View {
    
    @ObservedObject var vm = servicesViewModel()
    
    var body: some View {
        NavigationView{
        VStack (alignment: .leading) {
            Text("Sick Leaves/Vacations").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: viewMyLeaves()) {
                    box(title: "My Requests", image: "doc.on.doc.fill")
                    }
                    NavigationLink(destination: submitLeave()) {
                    box(title: "Submit Request", image: "paperplane.fill")
                    }
                    NavigationLink(destination: ViewLeaves()) {
                    box(title: "Approve/Reject", image: "checkmark.circle.fill")
                    }.opacity( vm.isUserManager == true ? 1 : 0)
                    
                }.padding()
            }
            Text("Notifications").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: informManager()) {
                    box(title: "Notify Manager", image: "bell.fill")
                    }
                    
                    NavigationLink(destination: viewEmployeesAttendanceStatus()) {
                    box(title: "View Statuses", image: "bell.badge.fill")
                    }.opacity( vm.isUserManager == true ? 1 : 0)
                }.padding()
            }

            Text("Other").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: ContentView()) {
                    box(title: "Generate Meeting", image: "plus.circle.fill")
                    }
                    NavigationLink(destination: announcementsView()) {
                    box(title: "Public Statements", image: "speaker.fill")
                    }
                    NavigationLink(destination: attendanceHistoryView()) {
                    box(title: "Attendance History", image: "magnifyingglass")
                    }
                }.padding()
            }
            Spacer()
        }.padding().navigationTitle("Services").navigationBarTitleDisplayMode(.inline)
        }
    }
}


class servicesViewModel: ObservableObject {
 
    @Published var isUserManager = false
    
    init() {
        isManager()
    }
    
func isManager () {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
   
   
        ref.child("Department").observe(.childAdded) { snapshot in
            
            let obj = snapshot.value as! [String: Any]
            let manager_id = obj["manager"] as! String
            
            print(manager_id)
            if ( manager_id == user!.uid ) {
                self.isUserManager = true
            }
        }
    print("XXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    print(isUserManager)
}
}

struct servicesView_Previews: PreviewProvider {
    static var previews: some View {
        servicesView()
    }
}

struct box: View {

    var title: String
    var image: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Image(systemName: image).foregroundColor(Color(red: 0.173, green: 0.694, blue: 0.937))
            Spacer()
            Text(title).bold().foregroundColor(.black)
        }.padding().frame(width: 130, height: 120).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
    }
}
