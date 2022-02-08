//
//  ChangePasswordView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 04/07/1443 AH.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var username: String = ""

    var body: some View {
        VStack {
            VStack(alignment:.leading){
                
                Text("Change")
                    .font(.system(size: 40.0))
                    .fontWeight(.light)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.032, brightness: 0.473)).padding(.leading,20)
                Text("Password")
                    .font(.system(size: 40.0))
                    .fontWeight(.semibold)
                    .padding(.top,0).padding(.leading,20)
                TextField("Enter the new password", text: $username)
                    .padding(.leading,20).padding(.trailing,20).padding(.top,100).foregroundColor(.cyan)
                Rectangle()
                    .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                
                                .foregroundColor(Color.cyan)
                TextField("Enter the new password again", text: $username)
                    .padding(.leading,20).padding(.trailing,20).padding(.top,30).foregroundColor(.cyan)
                Rectangle()
                    .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                
                    .foregroundColor(Color.cyan).padding(.bottom,50)
                HStack{
                Button(action: {
                    
                }) {
                    HStack {
//                                  Image(systemName: "gift")
                        Text("Update Password")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                    VStack(alignment: .leading) {
                        Text("Username")
                            .font(.callout)
                            .bold()
                        TextField("Enter username...", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding()
                .padding(17).padding(.leading,1)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 107/255, green: 200/255, blue: 244/255), Color(red: 104/255, green: 215/255, blue: 231/255)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(.infinity)

                }.padding(.leading,115)
    Spacer()
            }.padding(.top,90)
            
           


        }

        
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
