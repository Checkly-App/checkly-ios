//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//
import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var session: Session = Session()
    @State private var success: Bool = false
    @State private var error: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing: 40.0){
                TitleView(title: "Reset ", description: " your password by entering your work's email address")
                    .padding(.vertical, 20.0)
                EmailInputView(email: $session.credentials.email)
                    .alert(isPresented: $success) {
                        return Alert(title: Text("Success"), message: Text("Check your inbox for a reset message"))
                    }
                Button{
                    session.resetUserPassword { success in
                        self.success = success
                        error = !success
                    }
                } label: {
                    Text("Reset")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color("gradient-light-blue"),
                                Color("gradient-deep-blue")]),
                                           startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10.0)
                }
                .padding(.top, 20.0)
                .alert(isPresented: $error) {
                    return Alert(title: Text("Authentication Failed"), message: Text(session.error!.localizedDescription))
                }
                Spacer()
            }
            .disabled(session.showProgressView)
            .padding()
            .padding()
            if session.showProgressView {
                LoadingView()
            }
        }
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
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
        .foregroundColor(.accentColor)
        .preferredColorScheme(.light)
    }
}
