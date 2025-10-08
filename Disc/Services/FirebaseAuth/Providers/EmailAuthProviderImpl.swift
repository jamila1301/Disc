//
//  EmailAuthProviderImpl.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class EmailAuthProviderImpl: EmailAuthProvider {
    
    private let db = Firestore.firestore()
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Email sign out error: \(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async throws {
        
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error as NSError?,
                   let code = AuthErrorCode(rawValue: error.code) {
                    switch code {
                    case .invalidEmail: continuation.resume(throwing: AuthError.invalidEmail)
                    case .userNotFound: continuation.resume(throwing: AuthError.userNotFound)
                    case .wrongPassword: continuation.resume(throwing: AuthError.wrongPassword)
                    case .invalidCredential: continuation.resume(throwing: AuthError.invalidCredential)
                    case .userDisabled: continuation.resume(throwing: AuthError.userDisabled)
                    default: continuation.resume(throwing: AuthError.unknown(error.localizedDescription))
                    }
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
    
    func signUp(name: String, email: String, password: String) async throws {
        
        guard !name.isEmpty else { throw AuthError.emptyName }
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self else { return }
                if let error = error as NSError?,
                   let code = AuthErrorCode(rawValue: error.code) {
                    switch code {
                    case .emailAlreadyInUse: continuation.resume(throwing:AuthError.emailAlreadyInUse)
                    case .invalidEmail: continuation.resume(throwing: AuthError.invalidEmail)
                    case .weakPassword: continuation.resume(throwing: AuthError.weakPassword)
                    default: continuation.resume(throwing: AuthError.unknown(error.localizedDescription))
                    }
                    return
                }
                continuation.resume(returning: ())
                
                guard let uid = result?.user.uid else { return }
                
                self.db.collection("users").document(uid).setData([
                    "name": name,
                    "email": email
                ])
                
            }
            
        }
    }
    
    func resetPassword(email: String) async throws {
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error as NSError?,
                   let code = AuthErrorCode(rawValue: error.code) {
                    switch code {
                    case .invalidEmail: continuation.resume(throwing: AuthError.invalidEmail)
                    case .userNotFound: continuation.resume(throwing: AuthError.userNotFound)
                    default: continuation.resume(throwing: AuthError.unknown(error.localizedDescription))
                    }
                    return
                }
                continuation.resume(returning: ())
            }
        }
    }
    
}
