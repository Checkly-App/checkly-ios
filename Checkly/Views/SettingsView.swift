//
//  SettingsView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: - @State Varibales
    @State var goBackToHome = false
    @State var showLoginConfirmation = false
    
    //MARK: - @Environment Varibales
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        //1- container view
        VStack{
            List{
                //2- profile view button
                NavigationLink {
                    //TODO: Replace Text("Profile View") with the name of your view
                    Text("Profile View")
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Profile")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
                .padding()
                
                //3- terms and conditions view button
                NavigationLink {
                    TermsAndConditionsView()
                } label: {
                    HStack {
                        Image(systemName: "hand.raised")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Terms & Conditions")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
                .padding()
                
                
                
                //4- privacy and policy view button
                NavigationLink {
                    PrivacyAndPolicyView()
                } label: {
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Privay & Policy")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
                .padding()
                
                
                //5- logout button
                Button {
                    self.showLoginConfirmation.toggle()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.circle")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Logout")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
                .padding()
            }
        }
        .alert(isPresented: $showLoginConfirmation) {
            Alert(
                title: Text("Warning"),
                message: Text("Are you sure you want to Logout ?"),
                primaryButton: .destructive(Text("Logout")) {
                    //TODO: logout code goes here @DALAL
                },
                secondaryButton: .cancel()
            )
        }
    }
    //        }
    //        }
    //    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
