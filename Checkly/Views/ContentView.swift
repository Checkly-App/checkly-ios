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
