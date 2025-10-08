//
//  FirebaseAuthManagerImpl.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit

final class FirebaseAuthManagerImpl {
    
    private let emailProvider = EmailAuthProviderImpl()
    private let googleProvider = GoogleAuthProviderImpl()
    private let appleProvider = AppleAuthProviderImpl()
    private let facebookProvider = FacebookAuthProviderImpl()
    
    
    func signupWithEmail(name: String, email: String, password: String) async throws {
        try await emailProvider.signUp(name: name, email: email, password: password)
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        try await emailProvider.signIn(email: email, password: password)
    }
    
    func sendPasswordReset(email: String) async throws {
        try await emailProvider.resetPassword(email: email)
    }
    
    func loginWithGoogle(from view: UIViewController) async throws {
        try await googleProvider.signIn(from: view)
    }
    
    func loginWithApple(from view: UIViewController) async throws {
        try await appleProvider.signIn(from: view)
    }
    
    func loginWithFacebook(from view: UIViewController) async throws {
        try await facebookProvider.signIn(from: view)
    }
    
    func logoutAll() async {
        await emailProvider.signOut()
        await googleProvider.signOut()
        await appleProvider.signOut()
        await facebookProvider.signOut()
    }
    
}
