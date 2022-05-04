//
//  servicesView.swift
//  Checkly
//
//  Created by Norua Alsalem on 10/04/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ServicesView: View {
    
    @ObservedObject var vm = servicesViewModel()
    @State var generateMeetingView = false
    
    var body: some View {
        NavigationView{
        VStack (alignment: .leading) {
            Text("Sick Leaves/Vacations").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: MyLeavesView()) {
                    box(title: "My Requests", image: "doc.on.doc.fill")
                    }
                    NavigationLink(destination: SubmitLeaveView()) {
                    box(title: "Submit Request", image: "paperplane.fill")
                    }
                    NavigationLink(destination: LeavesView()) {
                    box(title: "Approve/Reject", image: "checkmark.circle.fill")
                    }.opacity( vm.isUserManager == true ? 1 : 0)
                    
                }.padding()
            }
            Text("Notifications").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: InformManagerView()) {
                    box(title: "Notify Manager", image: "bell.fill")
                    }
                    
                    NavigationLink(destination: EmployeesAttendanceStatusView()) {
                    box(title: "View Statuses", image: "bell.badge.fill")
                    }.opacity( vm.isUserManager == true ? 1 : 0)
                }.padding()
            }

            Text("Other").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
//                    NavigationLink(destination: GenerateMeetingView()) {
//                    box(title: "Generate Meeting", image: "plus.circle.fill")
//                    }
                    Button{
                        generateMeetingView.toggle()
                    } label: {
                        box(title: "Generate Meeting", image: "plus.circle.fill")
                    }
                    .fullScreenCover(isPresented: $generateMeetingView) {
                        GenerateMeetingView()
                    }
                    NavigationLink(destination: AnnouncementsView()) {
                    box(title: "Public Statements", image: "speaker.fill")
                    }
                    NavigationLink(destination: AttendanceHistoryView()) {
                    box(title: "Attendance History", image: "magnifyingglass")
                    }
                    // MARK: TO BE REMOVED
                    NavigationLink(destination: ContentView()) {
                    box(title: "Logout", image: "arrow.left.square")
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
        ServicesView()
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
        }.padding().frame(width: 130, height: 120).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .black.opacity(0.2), radius: 4, x: 0.1, y: 0.1))
    }
}
