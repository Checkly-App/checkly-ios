//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/03/2022.
//
import SwiftUI

struct FaceIDView: View {
    // MARK: - State Variables
    @StateObject var authentication = Authentication()
    @StateObject private var session: Session = Session()
    @State private var progressCounter = 0
    @State private var hasAppeared = false
    @Binding var storeCredentianlsNext: Bool
    
    // MARK: - Variables and Constants
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    var invalidPasswordError = "Your credentials have been changed recently. Would you like to save them?"
    
    // MARK: - Login with Face ID
    func loginWithBiometrics(){
        authentication.requestBiometricUnlock { [self] (result:Result<Credentials, Authentication.AuthenticationError>) in
            switch result {
            case .success(let credentials):
                progressCounter = 100
                session.credentials = credentials
                session.loginUser { success in
                    isLoggedIn = success
                }
            case .failure(let error):
                session.error = error
                progressCounter = 0
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top){
            /// Background gradient
            LinearGradient(gradient: Gradient(colors: [Color("gradient-light-blue"),
                                                       Color("gradient-deep-blue")]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            /// Main title
            VStack(alignment: .center, spacing: 8){
                Text("Login Via Face ID")
                    .font(.title)
                    .fontWeight(.bold)
                Text("login  with your Face ID, for a quick and secure login")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(EdgeInsets(top: 48, leading:16, bottom:0, trailing:16))
            /// Content
            VStack{
                Spacer()
                if session.error != nil {
                    ZStack(alignment: .center){
                        LinearGradient(gradient: Gradient(colors: [.white.opacity(0.4), .white.opacity(0.3)]),
                                       startPoint: .top, endPoint: .bottom)
                            .cornerRadius(15)
                        VStack(spacing: 10) {
                            /// Title
                            Text(session.error == .invalidPassword ? "Credentials Changed" : (session.error == .credentialsNotSaved ? "Credentials Not Saved" : "Authentication Failed"))
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(session.error == .invalidPassword ?  invalidPasswordError : session.error!.localizedDescription)
                                .multilineTextAlignment(.center)
                            /// Buttons
                            if session.error == .credentialsNotSaved || session.error == .invalidPassword {
                                Divider()
                                    .background(Color(UIColor(named: "Blue")!))
                                Button("**Save credentials**"){
                                    storeCredentianlsNext = true /// Change the binded object to reflect in login view
                                    session.error = nil
                                    dismiss()
                                }
                                Button("**Cancel**"){
                                    storeCredentianlsNext = false
                                    session.error = nil
                                    dismiss()
                                }
                            }
                            if session.error == .noFaceIdEnrolled || session.error == .noFingerprintEnrolled || session.error == .deniedAccess{
                                Divider()
                                    .background(Color(UIColor(named: "Blue")!))
                                Button("**Go to Settings**") {
                                    dismiss()
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                            }
                            if session.error == .exceededAttempts {
                                Divider()
                                    .background(Color(UIColor(named: "Blue")!))
                                Button("**Go back to login**"){
                                    session.error = nil
                                    dismiss()
                                }
                            }
                            if session.error == .cancelled {
                                Divider()
                                    .background(Color(UIColor(named: "Blue")!))
                                Button("**Go back to login**"){
                                    session.error = nil
                                    dismiss()
                                }
                                Button("**Retry**"){
                                    session.error = nil
                                    loginWithBiometrics()
                                }
                            }
                        }
                        .padding(16)
                    }
                    .padding(32)
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                else {
                    VStack(spacing: 15){
                        Text("\(progressCounter)%")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Verifying your face...")
                    }
                }
            }
            .padding()
            .padding()
            .onAppear(){
                loginWithBiometrics()
            }
        }
        
        .onReceive(timer) { time in
            if (session.error != nil) {
                progressCounter=0
            }
            else if progressCounter < 99 {
                progressCounter+=1
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(){
            ToolbarItem(placement: .navigationBarLeading){
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2){
                        Image(systemName: "arrow.backward")
                            .font(.body)
                        Text("")
                    }
                }
            }
        }
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        
    }
}

