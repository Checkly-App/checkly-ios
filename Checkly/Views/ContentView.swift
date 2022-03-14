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
    
    var body: some View {
        NavigationView{
            if isCompany {
//                ScannerView()
            }
            else{
                VStack{
                    
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
                        Calendar(viewRouter: viewRouter)
                    }

                }
            }
        }
        .onAppear {
            session.isCompanyEmail(currentEmail: email) { success in
                isCompany = success
                print("logged in as \(email)")
            }
        }
    }
}
