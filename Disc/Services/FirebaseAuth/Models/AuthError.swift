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
        case .emptyName: return "Name cannot be empty"
        case .emptyEmail: return "Email cannot be empty"
        case .emptyPassword: return "Password cannot be empty"
        case .invalidEmail: return "Email format is invalid"
        case .userNotFound: return "User not found"
        case .wrongPassword: return "Wrong password"
        case .invalidCredential: return "Email or password is incorrect"
        case .userDisabled: return "Account is disabled"
        case .emailAlreadyInUse: return "This email is already in use"
        case .weakPassword: return "Password must be at least 6 characters"
        case .unknown(let message): return message
        }
    }
}
