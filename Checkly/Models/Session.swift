//
//  LoginModel.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

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
        let ref = Database.database().reference()
        
        toggleProgress()
        
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [self] result, authError in
            toggleProgress()
            
            if authError != nil  {
                let authError = AuthErrorCode(rawValue: authError!._code)
                
                switch authError {
                case .invalidCredential:
                    error = .invalidCredentials
                case .wrongPassword:
                    error = .invalidPassword // The user has resetted their password
                default:
                    error = .invalidCredentials
                }
                
                if credentials.password.isEmpty || credentials.email.isEmpty {
                    error = .emptyCredentials
                }
                
                toggleError()
                completion(false)
            }
            
            if storeCredentialsNext {
                if KeychainStorage.saveCredentials(credentials){
                    storeCredentialsNext = false
                }
            }
            
            if result != nil {
                let uid = result!.user.uid
                
                ref.child("Login").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                    // user first time logging in
                    guard snapshot.exists() else {
                        ref.child("Login").child("\(uid)").updateChildValues(["loggedIn":"true"])
                        toggleSuccess()
                        completion(true)
                        return
                    }
                    // user has logged in before
                    let isLogged = snapshot.childSnapshot(forPath: "loggedIn").value as! String
                    if isLogged == "true"{ // check if there is an active session
                        error = .alreadyLoggedIn
                        toggleError()
                        completion(false)
                    }
                    else { // log user in if ther is no active sssion
                        ref.child("Login").child("\(uid)").updateChildValues(["loggedIn":"true"])
                        toggleSuccess()
                        completion(true)
                    }
                })
            }
        }
    }
    
    func signOutUser(completion: @escaping (Bool) -> Void){
        toggleProgress()
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid ?? "default"
        
        do {
            toggleProgress()
            try Auth.auth().signOut()
            ref.child("Login").child("\(uid)").updateChildValues(["loggedIn":"false"])
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
