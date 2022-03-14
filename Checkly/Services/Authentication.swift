//
//  Authentication.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isAuthorized = false
    
    enum BiometricType{
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable{
        case invalidCredentials
        case resetPassword
        case deniedAccess
        case credentialsNotSaved
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case invalidPassword
        case emptyCredentials
        case exceededAttempts
        case cancelled
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String?{
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Email or password are incorrect. Try again.", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have denied access. You can allow access from the Settings.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("In order to use Face ID, make sure to activate it first through the settings.", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("In order to use Touch ID, make sure to activate it first through the settings.", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Your credentials have not been saved yet. Would you like to save them?", comment: "")
            case .resetPassword:
                return NSLocalizedString("Your email does not match our records. Please try again or contact your organization.", comment: "")
            case .invalidPassword:
                return NSLocalizedString("Email or password are incorrect. Try again.", comment: "")
            case .emptyCredentials:
                return NSLocalizedString("Credentials should not be empty", comment: "")
            case .exceededAttempts:
                return NSLocalizedString("You have exceeded your attempts. Please login normally.", comment: "")
            case .cancelled:
                return NSLocalizedString("Operation was cancelled by the user.", comment: "")
            }
            
        }
    }
    // MARK: - Function that checks the device bimoetric type and returns it
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
    
    // MARK: - Function that fetches users credentials
    /// If the users credentials were not registered it will return a 'credentialsNotSaved' error
    /// If the user denied access it will return a 'deniedAccess' error
    /// If the user had not enrolled it will return a 'noFaceIdEnrolled' or 'noFingerprintEnrolled' error
    /// Otherwise the function returns the user's credentials
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
            print(error.code)
            switch error.code {
            case -6:
                print("denied access by user")
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.deniedAccess))
            }
            return
        }
        
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil  {
                            switch (error! as NSError).code {
                            case -6:
                                completion(.failure(.deniedAccess))
                            case -7:
                                if context.biometryType == .faceID {
                                    completion(.failure(.noFaceIdEnrolled))
                                } else {
                                    completion(.failure(.noFingerprintEnrolled))
                                }
                            case -3:
                                completion(.failure(.exceededAttempts))
                            default:
                                completion(.failure(.cancelled))
                            }
                        } else{
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}
