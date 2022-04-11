//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Logged in")
                Button{
                    do {
                        try Auth.auth().signOut()
                        authentication.updateValidation(success: false)
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                } label: {
                    Text("sign out")
                }
                
                Button(action: {
                    print("Floating Button Click")
                }, label: {
                    NavigationLink(destination: servicesView()) {
                         Text("Open View")
                     }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
