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
    @Published var showErrorView = false
    @Published var showSuccessView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeCredentialsNext = false
    
    func toggleProgress(){
        withAnimation { showProgressView.toggle() }
    }
    
    func toggleError(){
        withAnimation { showErrorView.toggle() }
    }
    
    func toggleSuccess(){
        withAnimation { showSuccessView.toggle() }
    }
    
    func loginUser(completion: @escaping (Bool) -> Void){
        
        toggleProgress()
        
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [self] result, authError in
            
            toggleProgress()
            
            if authError != nil  {
                let authError = AuthErrorCode(rawValue: authError!._code)
                switch authError {
                case .wrongPassword:
                    error = .invalidPassword // The user has resetted their password
                default:
                    error = .invalidCredentials
                }
                toggleError()
                completion(false)
            } else {
                if storeCredentialsNext{
                    if KeychainStorage.saveCredentials(credentials){
                        storeCredentialsNext = false
                    }
                }
                toggleSuccess()
                completion(true)
            }
        }
    }
    
    func signOutUser(completion: @escaping (Bool) -> Void){
        toggleProgress()
        
        do {
            toggleProgress()
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func resetUserPassword(completion: @escaping (Bool) -> Void){
        toggleProgress()
        Auth.auth().sendPasswordReset(withEmail: credentials.email) { [self] authError in
            toggleProgress()
            if authError != nil  {
                error = .resetPassword
                toggleError()
                completion(false)
            }
            else {
                toggleSuccess()
                completion(true)
            }
        }
    }
}


