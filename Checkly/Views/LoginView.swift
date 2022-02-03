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
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View{
        ZStack{
            BackgroundCheckView()
            VStack(spacing: 40.0){
                TitleView()
                    .padding(.vertical, 40.0)
                EmailInputView(email: $session.credentials.email)
                VStack (alignment: .trailing){
                    PasswordInputView(password: $session.credentials.password, isVisible: $isVisible)
                    ForgetPasswordView()
                }
                // MARK: - Login Button
                Button{
                    // Login user normally through email and password and updatet auth
                    session.loginUser { success in
                        isLoggedIn = success
                    }
                } label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 200.0, height: 45.0)
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(UIColor(named: "Blue")!),
                        Color(UIColor(named: "Green")!)]),
                                   startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30.0)
                // MARK: - FaceID Button
                // Check if the user's phone supports face or touch id
                if authentication.biometricType() != .none{
                    DividerView()
                    Button {
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
            .alert(item: $session.error) { error in
                switch error {
                case .credentialsNotSaved:
                    return Alert(title: Text("Credentials Not Saved"),
                                 message: Text(error.localizedDescription),
                                 primaryButton: .default(Text("OK"), action: {
                        session.storeCredentialsNext = true
                    }), secondaryButton: .cancel())
                default : return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
                }
            }
            .padding()
            if session.showProgressView {
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

// MARK: - Divider View
struct DividerView: View{
    var body: some View {
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
    }
}

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
                isVisible.toggle()
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
    }
}

// MARK: - Title View
struct TitleView: View {
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 25.0) {
                VStack(alignment: .leading, spacing: 5.0){
                    Text("Welcome")
                        .font(.system(size: 36.0))
                        .foregroundColor(Color(UIColor(named: "DeepBlue")!))
                    Text("Back !")
                        .font(.system(size: 40.0, weight: .bold))
                        .foregroundColor(Color(UIColor(named: "Navy")!))
                }
                Text("Login to your account and access your orginization's services")
                    .font(.body)
                    .foregroundColor(Color(UIColor(named: "DeepBlue")!))
            }
            Spacer()
        }
    }
}

// MARK: - Check View
struct BackgroundCheckView: View {
    var body: some View {
        VStack {
            Image("Intersect")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            Spacer()
        }
    }
}

// MARK: - Forget Password View
struct ForgetPasswordView: View {
    var body: some View {
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}











