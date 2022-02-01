//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 31/01/2022.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    // MARK: - Variables
    @StateObject private var loginModel: LoginModel = LoginModel()
    @EnvironmentObject var authentication: Authentication
    @State var isPasswordVisible : Bool = false
    
    var body: some View{
        ZStack {
            VStack(spacing: 32.0){
                // MARK: - Email Input
                HStack{
                    Image(systemName: "envelope.fill")
                    TextField("Email", text: $loginModel.credentials.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .overlay(Rectangle()
                            .frame(height: 1.5)
                            .padding(.top, 35.0))
                .foregroundColor(loginModel.credentials.email.isEmpty ?
                                 Color(UIColor(named: "LightGray")!) :
                                    Color(UIColor(named: "Blue")!))
                // MARK: - Password Input
                VStack (alignment: .trailing){
                    HStack{
                        Image(systemName: "lock.fill")
                        if !isPasswordVisible {
                            SecureField("Password", text: $loginModel.credentials.password)
                        }
                        else {
                            TextField("Password", text: $loginModel.credentials.password)
                        }
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                        }
                        
                    }
                    .overlay(Rectangle()
                                .frame(height: 1.5)
                                .padding(.top, 35.0))
                    .foregroundColor(loginModel.credentials.password.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
                    Button{
                        // Reset password
                    } label: {
                        Text("Forgot password?")
                            .fontWeight(.bold)
                            .font(.caption)
                            .foregroundColor(Color(UIColor(named: "Blue")!))
                    }
                    .padding(.vertical, 10.0)
                }
                // MARK: - Login Button
                Button{
                    // Login user normally through email and password and updatet auth
                    loginModel.loginUser { success in
                        authentication.updateValidation(success: success)
                    }
                } label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 150.0, height: 45.0)
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(UIColor(named: "Blue")!),
                        Color(UIColor(named: "Green")!)]),
                                   startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
                
                ZStack{
                    Divider()
                        .background(Color(UIColor(named: "Gray")!))
                        .padding(.horizontal, 25.0)
                    Text("or")
                        .fontWeight(.light)
                        .foregroundColor(Color(UIColor(named: "Gray")!))
                        .padding(.horizontal, 15.0)
                        .background(.white)
                }
                // MARK: - FaceID Button
                // Check if the user's phone supports face or touch id
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
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(.white)
                                .frame(width: 65.0, height: 65.0)
                                .shadow(color: Color(UIColor(named: "Shadow")!), radius: 10, x: 0.5, y: 2)
                            Image(systemName: "faceid")
                                .resizable()
                                .frame(width: 28.0, height: 28.0)
                                .foregroundColor(Color(UIColor(named: "Gray")!))
                        }
                        .padding()
                    }
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
            .padding()
            
            if loginModel.showProgressView {
                LoadingView()
            }
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15.0)
                .fill(Color(UIColor(named: "Loading")!))
                .frame(width: 200, height: 200)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(named: "Green")!)))
                .scaleEffect(1.5)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
    }
}


