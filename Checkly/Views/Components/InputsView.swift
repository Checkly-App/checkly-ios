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
        VStack(alignment: .leading) {
            Text("Email")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(UIColor(named: "LightGray")!))
            TextField("type your email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(email.isEmpty ?
                                    Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                .foregroundColor(email.isEmpty ?
                                 Color(UIColor(named: "LightGray")!) :
                                    Color(UIColor(named: "Blue")!))
        }
        .animation(.default)
        
    }
}

// MARK: - Password Input View
struct PasswordInputView: View {
    @Binding var password: String
    @Binding var isVisible: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(UIColor(named: "LightGray")!))
            HStack{
                if !isVisible {
                    SecureField("type your password", text: $password)
                }
                else {
                    TextField("type your password", text: $password)
                }
                Button {
                    withAnimation{
                        isVisible.toggle()
                    }
                    
                } label: {
                    Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                }
                
            }
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .stroke(password.isEmpty ?
                                Color(UIColor(named: "LightGray")!) :
                                    Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
            .foregroundColor(password.isEmpty ?
                             Color(UIColor(named: "LightGray")!) :
                                Color(UIColor(named: "Blue")!))
        }
        .animation(.default)
    }
}
