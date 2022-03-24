//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 31/01/2022.
//

import SwiftUI


struct LoginView: View {
    // MARK: - @State Object
    @StateObject private var loginModel: LoginModel = LoginModel()
    @EnvironmentObject var authentication: Authentication
    
    // MARK: - @State Variables
    @State var editingEmail = false
    @State var editingPassword = false
    
    var body: some View {
        VStack(spacing: 20.0){
            TextField("Email", text: $loginModel.credentials.email, onEditingChanged: { edit in
                editingEmail = edit
            })
                .textFieldStyle(ChecklyTextFieldStyle(focused: $editingEmail))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $loginModel.credentials.password)
                .textFieldStyle(ChecklyTextFieldStyle(focused: $editingPassword))
            
            if loginModel.showProgressView {
                ProgressView()
            }
            
            Button{
                // Login user normally
                loginModel.loginUser { success in
                    authentication.updateValidation(success: success)
                }
                
            } label: {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(loginModel.loginDisabled)
            .background(.blue)
            .cornerRadius(10)
            
            if authentication.biometricType() != .none{
                Button {
                    // Login using biometrics
                    authentication.requestBiometricUnlock { (result:Result<Credentials, Authentication.AuthenticationError>) in
                        switch result {
                        case .success(let credentials):
                            loginModel.credentials = credentials
                            loginModel.loginUser { success in
                                authentication.updateValidation(success: success)
                            }
                        case .failure(let error):
                            loginModel.error = error
                        }
                    }
                } label:{
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.gray)
                }
                .background(.white)
                .padding(25)
                .shadow(color: .gray, radius: 5, x: 0.5, y: 2)
            }
        }
        .disabled(loginModel.showProgressView)
        .padding()
        .alert(item: $loginModel.error) { error in
            if error == .credentialsNotSaved {
                return Alert(title: Text("Credentials Not Saved"),
                             message: Text(error.localizedDescription),
                             primaryButton: .default(Text("OK"), action: {
                    loginModel.storeCredentialsNext = true
                }),
                             secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
            }
        }
        
    }
}

// MARK: - Custom text field
struct ChecklyTextFieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(focused ? Color.blue : Color.gray, lineWidth: 1)
            )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
    }
}

