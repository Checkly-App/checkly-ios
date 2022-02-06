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
    
    var body: some View{
        NavigationView {
            ZStack{
                BackgroundCheckView()
                VStack(spacing: 40.0){
                    TitleView(title: "Welcome", subTitle: "Back !", description: "Login to your account and access your organization's services")
                        .padding(.top, 60.0)
                    EmailInputView(email: $session.credentials.email)
                        .padding(.top, 20.0)
                    VStack (alignment: .trailing){
                        PasswordInputView(password: $session.credentials.password, isVisible: $isVisible)
                        NavigationLink(destination: ResetPasswordView()){
                            Text("Forgot password?")
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundColor(Color(UIColor(named: "Blue")!))
                                .padding(.vertical, 10.0)
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
                            .frame(width: 200.0, height: 45.0)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(UIColor(named: "Blue")!),
                                    Color(UIColor(named: "Green")!)]),
                                               startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(30.0)
                    }
                    // MARK: - FaceID Button
                    // Check if the user's phone supports face or touch id
                    if authentication.biometricType() != .none{
                        DividerView()
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
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(.white)
                                    .frame(width: 65.0, height: 65.0)
                                    .shadow(color: Color(UIColor(named: "Shadow")!), radius: 5, x: 0.5, y: 2)
                                Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                                    .font(.system(size: 32.0, weight: .light))
                                    .foregroundColor(Color(UIColor(named: "Navy")!))
                            }
                            .padding()
                        }
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
            }
            .navigationBarTitle("Login", displayMode: .large)
            .navigationBarHidden(true)
            .background(Color(UIColor(.white)))
        }
    }
}

// MARK: - Divider View
struct DividerView: View{
    var body: some View {
        ZStack{
            Divider()
                .background(Color(UIColor(named: "LightGray")!))
                .padding(.horizontal, 25.0)
            Text("or")
                .fontWeight(.light)
                .foregroundColor(Color(UIColor(named: "LightGray")!))
                .padding(.horizontal, 15.0)
                .background(Color(UIColor(.white)))
        }
    }
}

// MARK: - Check View
struct BackgroundCheckView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Image(colorScheme == .light ? "backgroundLight" : "backgroundDark" )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            Spacer()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}











