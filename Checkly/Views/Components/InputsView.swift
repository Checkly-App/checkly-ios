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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("light-gray"))
            TextField("type your email", text: $email)
                .modifier(ClearButton(text: $email))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(email.isEmpty ? Color("light-gray") : .accentColor , lineWidth: 0.5))
                .foregroundColor(email.isEmpty ? Color("light-gray") : .accentColor)
        }
        .animation(.default, value: email)
    }
}

// MARK: - Text Input View
struct TextInputView: View {
    @Binding var text: String
    
    var title: String
    var placeHolder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("light-gray"))
            TextField(placeHolder, text: $text)
                .modifier(ClearButton(text: $text))
                .autocapitalization(.none)
                .keyboardType(title == "Phone Number" ? .phonePad: .alphabet)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(text.isEmpty ? Color("light-gray") : .accentColor , lineWidth: 0.5))
                .foregroundColor(text.isEmpty ? Color("light-gray") : .accentColor)
        }
        .animation(.default, value: text)
    }
}

// MARK: - Password Input View
struct PasswordInputView: View {
    @Binding var password: String
    @Binding var isVisible: Bool
    
    var title: String!
    var placeHolder: String!
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title ?? "Password")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("light-gray"))
            HStack{
                if !isVisible  {
                    SecureField(placeHolder ?? "type your password", text: $password)
                }
                else {
                    TextField(placeHolder ?? "type your password", text: $password)
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
                                Color("light-gray") : .accentColor , lineWidth: 0.5))
            .foregroundColor(password.isEmpty ? Color("light-gray") : .accentColor)
        }
        .animation(.default, value: password)
    }
}

public struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(Color("light-gray"))
                .opacity(text == "" ? 0 : 1)
                .onTapGesture { self.text = "" }
        }
    }
}
