//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var session: Session = Session()
    @State private var emailSuccess: Bool = false
    
    var body: some View {
        ZStack(alignment: .top){
            BackgroundCheckView()
            VStack(spacing: 40){
    
                TitleView(title: "Password", subTitle: "Reset", description: "Enter your orgizatnion's associated email address and we will send you the instructions!")
                    .padding(.vertical, 20.0)

                EmailInputView(email: $session.credentials.email)
                Button{
                    session.resettUserPassword { success in
                        emailSuccess = success
                    }
                } label: {
                    Text("Reset")
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
                .alert("Success", isPresented: $emailSuccess){
                    Button("Got it!", role: .cancel){}
                }
                Spacer()
            }
            .disabled(session.showProgressView)
            .padding()
            .alert(item: $session.error) { error in
                return Alert(title: Text("Invalid Credentials"), message: Text(error.localizedDescription))
                
            }
            .padding()
            if session.showProgressView {
                LoadingView()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .alert(item: $session.error) { error in
            return Alert(title: Text("Invalid Reset"), message: Text(error.localizedDescription))
        }
        
    }
}

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
