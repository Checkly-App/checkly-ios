//
//  ChangePasswordView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 05/07/1443 AH.
//

import SwiftUI
import FirebaseAuth
import AlertToast
import SPAlert
struct ChangePasswordView: View {
    @StateObject private var session: Session = Session()
    @State var password = ""
    @State var passwordAgain = ""
    @State var error = ""
    @State var title = ""
    @State var passeroor = ""

    @State var passAgainerror = ""


    @State private var showingAlert = false



    @State var isVisible = false
    @State var isVisible2 = false

    var body: some View {
        
        ZStack(){
            BackgroundCheckView()
            VStack(spacing: 40){
                TitleView(title: "Change", subTitle: "Password", description: "")
                    .padding(.vertical, 20.0)
                VStack(alignment:.trailing){
                    HStack{
                        Image(systemName: "lock.fill")
                        if !isVisible {
                            SecureField("Enter the  new Password", text: $password)
                        }
                        else {
                            TextField("Enter the new Password", text: $password)
                        }
                        Button {
                            withAnimation{
                                isVisible.toggle()
                            }
                            
                        } label: {
                            Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                        }

                    }.padding(.top,0)
                    .overlay(Rectangle()
                                .frame(height: 1.5)
                                .padding(.top, 35.0))
                    .foregroundColor(password.isEmpty ?
                                     Color(UIColor(named: "LightGray")!)
                                     : Color(UIColor(named: "Blue")!))
                    .animation(.default)
                    Text(passeroor)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color("Blue"))
                        .multilineTextAlignment(.trailing).onChange(of: password) { newValue in
                             if password == ""{
                              passeroor = "Can not be empty"
                          }
                           else if (password.count <= 6)  {
                                passeroor = "the length must be at least 7"
                            }                         else{
                                passeroor = ""
                            }
                           
                        }
                }
                VStack(alignment:.trailing){
                HStack{
                    Image(systemName: "lock.fill")
                    if !isVisible2 {
                        SecureField("Enter the cinfirme password", text: $passwordAgain)
                    }
                    else {
                        TextField("Enter the confire password", text: $passwordAgain)
                    }
                    Button {
                        withAnimation{
                            isVisible2.toggle()
                        }
                        
                    } label: {
                        Image(systemName: isVisible2 ? "eye.fill" : "eye.slash.fill")
                    }
                    
                }
                .overlay(Rectangle()
                            .frame(height: 1.5)
                            .padding(.top, 35.0))
                .foregroundColor(password.isEmpty ?
                                 Color(UIColor(named: "LightGray")!)
                                 : Color(UIColor(named: "Blue")!))
                .animation(.default)
                    Text(passAgainerror)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color("Blue"))
                        .multilineTextAlignment(.leading).onChange(of: passwordAgain) { newValue in
                            if passwordAgain == ""{
                                passAgainerror = "Can not be empty"
                            }
                            else if (passwordAgain.count <= 6)  {
                                passAgainerror = "The length must be at least 7"
                            }else{
                                passAgainerror = ""
                            }
                            if passwordAgain != password{
                                passAgainerror = "Not match with the password"
                            }else{
                                passAgainerror = ""
                            }
                          
                        }
                }
                Button{
                    if Validation(){
                    Auth.auth().currentUser?.updatePassword(to: password) { error in
                      // ...
                        print(error?.localizedDescription as Any)
                    
                    }
                        title = "Great!"
                        error = "The password change successfully"
                        
                        showingAlert = true

                    }
                    else{
                        showingAlert = true

                    }
                } label: {
                    Text("Update Password")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200.0, height: 45.0)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color(UIColor(named: "Blue")!),
                                Color(UIColor(named: "Green")!)]),
                                           startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(30.0).padding(.top,50)  .alert(isPresented: $showingAlert) {
                            Alert(title: Text(title), message: Text(error), dismissButton: .default(Text("Got it!")))
                        }
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
    func Validation() -> Bool {

        if password != passwordAgain{
            error = "The paswwords and the confirme password must be same"
            title = "Oops!"
            return false
        }
        if password == "" || passwordAgain == ""{
            error = "All feilds are required "
            title = "Oops!"

            return false
        }
        if (password.count <= 6)  {
            error = "the leangth of password musr be at least 7 "
            title = "Oops!"

            return false
        }
        if (passwordAgain.count <= 6) {
            error = "the leangth of password musr be at least 7 "
            title = "Oops!"

            return false
        }
          return true
}
}
struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
