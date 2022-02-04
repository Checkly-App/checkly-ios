//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var session: Session = Session()
    
    var body: some View {
        ZStack{
            BackgroundCheckView()
            VStack(spacing: 40.0){
                TitleView(title: "Welcom", subTitle: "Back !", description: "Login to your account and access your orginization's services")                    .padding(.vertical, 40.0)
                EmailInputView(email: $session.credentials.email)
                
                // MARK: - Reset Button
                Button{
                    
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
        
        
    }
}

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
