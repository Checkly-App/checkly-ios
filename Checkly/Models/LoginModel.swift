//
//  LoginModel.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import FirebaseAuth

class LoginModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeCredentialsNext = false
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    func loginUser(completion: @escaping (Bool) -> Void){
        showProgressView = true
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [self] result, authError in
            showProgressView = false
            
            if let authError = authError  {
                print("an error occured \(authError)")
                credentials = Credentials() // Reset to empty
                error = .invalidCredentials
                completion(false)
            }else{
                if storeCredentialsNext{
                    if KeychainStorage.saveCredentials(credentials){
                        storeCredentialsNext = false
                    }
                }
                completion(true)
                print("success")
            }
        }
    }
}


