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
    var body: some View {
        NavigationView{
        VStack (alignment: .leading) {
            Text("Sick Leaves/Vacations").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: ContentView()) {
                    box(title: "My Requests", image: "doc.on.doc.fill")
                    }
                    NavigationLink(destination: ContentView()) {
                    box(title: "Submit Request", image: "paperplane.fill")
                    }
                    if ( isManager() ) {
                    NavigationLink(destination: ContentView()) {
                    box(title: "Approve/Reject", image: "checkmark.circle.fill")
                    }
                    }
                }.padding()
            }
            Text("Notifications").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: ContentView()) {
                    box(title: "Notify Manager", image: "bell.fill")
                    }
                    if ( isManager() ) {
                    NavigationLink(destination: ContentView()) {
                    box(title: "View Statuses", image: "bell.badge.fill")
                    }
                    }
                }.padding()
            }

            Text("Other").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    NavigationLink(destination: ContentView()) {
                    box(title: "Generate Meeting", image: "plus.circle.fill")
                    }
                    NavigationLink(destination: ContentView()) {
                    box(title: "public Statements", image: "speaker.fill")
                    }
                }.padding()
            }
            Spacer()
        }.padding().navigationTitle("Services").navigationBarTitleDisplayMode(.inline)
        }
    }
}

func isManager () -> Bool {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var isManager = false
   
        ref.child("Department").observe(.childAdded) { snapshot in
            
            let obj = snapshot.value as! [String: Any]
            let manager_id = obj["manager"] as! String
            
            if ( manager_id == user!.uid ) {
                isManager = true
            }
        }
    return isManager
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
