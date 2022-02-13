//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//


import SwiftUI
import PopupView

struct ResetPasswordView: View {
    @StateObject private var session: Session = Session()
    @State private var resetPressed: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 40.0){
                TitleView(title: "Reset ", description: "your password by entering your organization's associated email address")
                    .padding(.vertical, 20.0)
                EmailInputView(email: $session.credentials.email)
                Button{
                    session.resetUserPassword { _ in
                        resetPressed = true
                    }
                } label: {
                    Text("Reset")
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
                Spacer()
            }
            .disabled(session.showProgressView)
            .padding()
            .padding()
            
            if session.showProgressView {
                LoadingView()
            }
        }
        .popup(isPresented: $session.showErrorView, closeOnTapOutside: true) {
            FeedbackView(imageName: "xmark",
                         title: "Reset Failed",
                         message: session.error!.localizedDescription)
        }
        .popup(isPresented: $session.showSuccessView, closeOnTapOutside: true) {
            FeedbackView(imageName: "checkmark",
                         title: "Success",
                         message: "Check your inbox for a reset message")
        }
        .background(Color(UIColor(.white)))
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
