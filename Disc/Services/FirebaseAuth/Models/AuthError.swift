//
//  AuthError.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case emptyName
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case userNotFound
    case wrongPassword
    case invalidCredential
    case userDisabled
    case emailAlreadyInUse
    case weakPassword
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyName: return "error_empty_name".localized()
        case .emptyEmail: return "error_empty_email".localized()
        case .emptyPassword: return "error_empty_password".localized()
        case .invalidEmail: return "error_invalid_email".localized()
        case .userNotFound: return "error_user_not_found".localized()
        case .wrongPassword: return "error_wrong_password".localized()
        case .invalidCredential: return "error_invalid_credential".localized()
        case .userDisabled: return "error_user_disabled".localized()
        case .emailAlreadyInUse: return "error_email_already_in_use".localized()
        case .weakPassword: return "error_weak_password".localized()
        case .unknown(let message): return message
        }
    }
}
