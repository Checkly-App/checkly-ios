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
    @StateObject var authentication = Authentication()
    @StateObject private var session: Session = Session()
    @State private var isVisible: Bool = false
    @State private var navigateToReset: Bool = false
    @State private var faceIDPressed: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 40.0) {
                    TitleView(title: "Sign in", description: "to your account and access your organization's services")
                        .padding(.top, 60.0)
                    VStack(spacing: 12.5){
                        EmailInputView(email: $session.credentials.email)
                        VStack (alignment: .trailing){
                            PasswordInputView(password: $session.credentials.password, isVisible: $isVisible)
                            NavigationLink(destination: ResetPasswordView()){
                                Text("Forgot password?")
                                    .fontWeight(.bold)
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor(named: "Blue")!))
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                    
                    // MARK: - Login Button
                    Button{
                        faceIDPressed = false
                        // Login user normally through email and password and update auth
                        session.loginUser { success in
                            isLoggedIn = success
                        }
                    } label: {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(UIColor(named: "Blue")!),
                                    Color(UIColor(named: "LightTeal")!)]),
                                               startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10.0)
                    }
                    .padding(.top, 20.0)
                    
                    // MARK: - FaceID Button
                    // Check if the user's phone supports face or touch id
                    if authentication.biometricType() != .none{
                        DividerView()
                            .padding(.top, 45.0)
                        Button {
                            faceIDPressed = true
                            // Login using biometrics
                            authentication.requestBiometricUnlock { (result:Result<Credentials, Authentication.AuthenticationError>) in
                                switch result {
                                case .success(let credentials):
                                    session.credentials = credentials
                                    session.loginUser { success in
                                        isLoggedIn = success
                                    }
                                case .failure(let error):
                                    session.error = error
                                }
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                    .fill(.white)
                                    .frame(width: 50.0, height: 50.0)
                                    .shadow(color: Color(UIColor(named: "Shadow")!), radius: 5, x: 0.5, y: 2)
                                Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                                    .font(.system(size: 28.0, weight: .light))
                                    .foregroundColor(Color(UIColor(named: "Navy")!))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .disabled(session.showProgressView)
                .padding()
                .padding()
                .alert(item: $session.error) { error in
                    switch error {
                    case .invalidPassword:
                        if faceIDPressed {
                            return Alert(title: Text("Credentials Changed"),
                                         message: Text("Your credentials have been changed recently, login normally and we will save and update your credentials to login through biometrics!"),
                                         primaryButton: .default(Text("OK"), action: {
                                session.storeCredentialsNext = true
                            }), secondaryButton: .cancel())
                        }
                        else {
                            return Alert(title: Text("Authentication Failed"), message: Text(error.localizedDescription))
                        }
                    case .credentialsNotSaved:
                        return Alert(title: Text("Credentials Not Saved"),
                                     message: Text(error.localizedDescription),
                                     primaryButton: .default(Text("OK"), action: {
                            session.storeCredentialsNext = true
                        }), secondaryButton: .cancel())
                    default : return Alert(title: Text("Authentication Failed"), message: Text(error.localizedDescription))
                    }
                }
                
                if session.showProgressView {
                    LoadingView()
                }
                
                //                if session.showErrorView {
                //                    if faceIDPressed && (session.error == .invalidPassword || session.error == .credentialsNotSaved){
                //                        FeedbackView(imageName: "xmark", title: "Authentication Failed", message: "Your credentials have changed. We will update them after the next successful login!")
                //                            .onTapGesture {
                //                                session.toggleError()
                //                                session.storeCredentialsNext = true
                //                            }
                //                    }
                //                    else {
                //                        FeedbackView(imageName: "xmark", title: "Authentication Failed", message: session.error!.localizedDescription)
                //                            .onTapGesture { session.toggleError() }
                //                    }
                //                }
                
            }
            .background(Color(UIColor(.white)))
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Divider View
struct DividerView: View{
    var body: some View {
        ZStack{
            Divider()
                .background(Color(UIColor(named: "LightGray")!))
                .padding(.horizontal, 25.0)
            Text("or sign in with")
                .font(.system(size: 14))
                .foregroundColor(Color(UIColor(named: "LightGray")!))
                .padding(.horizontal, 15.0)
                .background(Color(UIColor(.white)))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}











