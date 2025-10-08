//
//  SignupViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

protocol SignupViewModelProtocol {
    func signupWithEmail(name: String, email: String, password: String) async throws
    func loginWithGoogle() async throws
    func loginWithApple() async throws
    func loginWithFacebook() async throws
    func navigateToSignin()
}

final class SignupViewModel: SignupViewModelProtocol {
    private let authManager = FirebaseAuthManagerImpl()
    private var router: SignupRouterProtocol
    
    init(router: SignupRouterProtocol) {
        self.router = router
    }
    
    func signupWithEmail(name: String, email: String, password: String) async throws {
        try await authManager.signupWithEmail(name: name, email: email, password: password)
        await MainActor.run {
            router.navigateHome()
        }
    }
    
    func loginWithGoogle() async throws {
        try await authManager.loginWithGoogle(from: router.view ?? UIViewController())
        await MainActor.run {
            router.navigateHome()
        }
    }
    
    func loginWithApple() async throws {
        try await authManager.loginWithApple(from: router.view ?? UIViewController())
        await MainActor.run {
            router.navigateHome()
        }
    }
    
    func loginWithFacebook() async throws {
        try await authManager.loginWithFacebook(from: router.view ?? UIViewController())
        await MainActor.run {
            router.navigateHome()
        }
    }
    
    func navigateToSignin() {
        router.navigateToSignin()
    }
    
}
