//
//  Authentication.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    
    enum BiometricType{
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable{
        case invalidCredentials
        case deniedAccess
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String?{
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Email or Password are incorrect", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have denied access to face id. this can be changed in the settings", comment: "")
            case .biometricError:
                return NSLocalizedString("Face id does not match", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Your credentials have not been saved, would you like to save them?", comment: "")
            }
            
        }
    }
    
    func updateValidation(success: Bool){
        withAnimation {
            isValidated = success
        }
    }
    
    func biometricType()-> BiometricType{
        let context = LAContext()
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType{
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return.face
        @unknown default:
            return .none
        }
        
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
        let credentials = KeychainStorage.getCredentials()
        guard let credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}

