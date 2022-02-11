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
    @EnvironmentObject var authentication: Authentication
    @AppStorage("isLoggedIn") var isLoggedIn = true

    var body: some View {
        NavigationView{
            VStack{
                Text("Logged in")
                Button{
                    session.signOutUser { success in
                        isLoggedIn = !success
                    }
                } label: {
                    Text("sign out")
                }
            
            NavigationLink( destination: UserProfileView()){
                Text("Profile")
            }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
