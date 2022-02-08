//
//  UIedit.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 04/07/1443 AH.
//

import SwiftUI

struct UIedit1: View {
    @State private var username: String = ""
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                    .bold()
                TextField("Enter username...", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).foregroundColor(.cyan).disabled(true)
            }.padding()
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                    .bold()
                TextField("Enter username...", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).foregroundColor(.cyan)
            }.padding()
            
        }
         
    }}

struct UIedit: View {
    var body: some View {
        VStack{
            Button {
                        print("Image tapped!")
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.cyan)
                    }.padding(.trailing,350).padding()
            
            
            Text("Edit Profile ").font(.largeTitle).fontWeight(.light).foregroundColor(Color.gray).padding(.top,20).padding(.trailing,200)
            Button {
                        print("Image tapped!")
                    } label: {
                        Image(systemName:"person.circle.fill")
                        .imageScale(.large).foregroundColor(Color.cyan).font(.system(size: 100.0)).padding(.top,1)}.foregroundColor(.cyan).shadow(radius: 12)
            
            UIedit1()
            Button(action: {
                
            }) {
                HStack {
//                                  Image(systemName: "gift")
                    Text("Update Profile")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
            }
            .padding(17).padding(.leading,1)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 107/255, green: 200/255, blue: 244/255), Color(red: 104/255, green: 215/255, blue: 231/255)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(.infinity)

        
            
    
            Spacer()
        }
    }
}

struct UIedit_Previews: PreviewProvider {
    static var previews: some View {
        UIedit()
    }
}
