//
//  LoginModel.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import FirebaseAuth

class Session: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeCredentialsNext = false
    
    func loginUser(completion: @escaping (Bool) -> Void){
        showProgressView = true
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [self] result, authError in
            showProgressView = false
            
            if authError != nil  {
                error = .invalidCredentials
                completion(false)
            } else {
                if storeCredentialsNext{
                    if KeychainStorage.saveCredentials(credentials){
                        storeCredentialsNext = false
                    }
                }
                completion(true)
            }
        }
    }
    
    func signOutUser(completion: @escaping (Bool) -> Void){
        showProgressView = true
        
        do {
            try Auth.auth().signOut()
            showProgressView = false
            completion(true)
        } catch {
            showProgressView = false
            completion(false)
            
        }
    }
    
    func resettUserPassword(completion: @escaping (Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: credentials.email) { [self] authError in
            if authError != nil  {
                error = .resetPassword
                completion(false)
            }
            completion(true)
        }
    }
}


