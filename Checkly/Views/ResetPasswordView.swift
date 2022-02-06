//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//

import SwiftUI
import AlertToast
import SPAlert

struct ResetPasswordView: View {
    @StateObject private var session: Session = Session()
    
    var body: some View {
        ZStack(){
            BackgroundCheckView()
            VStack(spacing: 40){
                TitleView(title: "Password", subTitle: "Reset", description: "Enter your organization's associated email address and we will send you the instructions!")
                    .padding(.vertical, 20.0)
                EmailInputView(email: $session.credentials.email)
                Button{
                    session.resetUserPassword { _ in }
                } label: {
                    Text("Reset")
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
                Spacer()
            }
            .disabled(session.showProgressView)
            .padding()
            .padding()
            if session.showProgressView {
                LoadingView()
            }
            if session.showErrorView {
                FeedbackView(imageName: "xmark", title: "Oops", message: session.error!.localizedDescription)
                    .onTapGesture {
                        session.toggleError()
                    }
            }
            else if session.showSuccessView {
                FeedbackView(imageName: "checkmark", title: "Success", message: "Check your inbox for a reset message")
                    .onTapGesture {
                        session.toggleSuccess()
                    }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        
        
        
    }
}

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
