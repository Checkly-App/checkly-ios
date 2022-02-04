//
//  InputsView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//

import SwiftUI

// MARK: - Email Input View
struct EmailInputView: View {
    @Binding var email: String
    var body: some View {
        HStack{
            Image(systemName: "envelope.fill")
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        .overlay(Rectangle()
                    .frame(height: 1.5)
                    .padding(.top, 35.0))
        .foregroundColor(email.isEmpty ?
                         Color(UIColor(named: "LightGray")!) :
                            Color(UIColor(named: "Blue")!))
        .animation(.default)
    }
}

// MARK: - Password Input View
struct PasswordInputView: View {
    @Binding var password: String
    @Binding var isVisible: Bool
    var body: some View {
        HStack{
            Image(systemName: "lock.fill")
            if !isVisible {
                SecureField("Password", text: $password)
            }
            else {
                TextField("Password", text: $password)
            }
            Button {
                withAnimation{
                    isVisible.toggle()
                }
                
            } label: {
                Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
            }
            
        }
        .overlay(Rectangle()
                    .frame(height: 1.5)
                    .padding(.top, 35.0))
        .foregroundColor(password.isEmpty ?
                         Color(UIColor(named: "LightGray")!)
                         : Color(UIColor(named: "Blue")!))
        .animation(.default)
    }
}
