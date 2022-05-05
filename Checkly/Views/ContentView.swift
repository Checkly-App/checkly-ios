//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var session: Session = Session()
    @AppStorage("isLoggedIn") var isLoggedIn = true
    @AppStorage("isSignedOut") var isSignedOut = false
    let email: String = Auth.auth().currentUser?.email ?? " "
    @State var isCompany = false
    @StateObject var viewRouter = CalendarViewRouterHelper()
    @State var calendarView = false
    @State var profileView = false
    @State var servicesView = false
    
    var uid = Auth.auth().currentUser?.uid ?? "null"
    
    init(){
        NotificationManager.instance.requestAuthorization()
        NotificationManager.instance.meetingNotificationListener(uid: uid)
    }
    
    var body: some View {
        NavigationView {
         
                VStack(spacing: 10){
                    
                    Text("Logged in as \(email)")
                    
                    Button{
                        session.signOutUser { success in
                            isLoggedIn = !success
                            isSignedOut = success
                        }
                    } label: {
                        Text("sign out")
                    }
                    
                    // navigate to calendar view
                    Button{
                        calendarView.toggle()
                    } label: {
                        Text("Calendar")
                    }
                    .fullScreenCover(isPresented: $calendarView) {
                        CalendarView(viewRouter: viewRouter)
                    }
                    
                    // navigate to profile view
                    Button{
                        profileView.toggle()
                    } label: {
                        Text("Profile")
                    }
                    .fullScreenCover(isPresented: $profileView) {
                        UserProfileView()
                    }
                    // navigate to services view
                    Button{
                        servicesView.toggle()
                    } label: {
                        Text("Services")
                    }
                    .fullScreenCover(isPresented: $servicesView) {
                        ServicesView()
                    }
                    
                }
                .preferredColorScheme(.light)
            }
                
    }
}
