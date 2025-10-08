//
//  LoginViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit

protocol LoginViewModelProtocol {
    func loginWithEmail(email: String, password: String) async throws
    func loginWithGoogle() async throws
    func loginWithApple() async throws
    func loginWithFacebook() async throws
    func navigateToForgotPassword()
    func navigateToSignup()
}

final class LoginViewModel: LoginViewModelProtocol {
    private let authManager = FirebaseAuthManagerImpl()
    private var router: LoginRouterProtocol
    
    init(router: LoginRouterProtocol) {
        self.router = router
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        try await authManager.loginWithEmail(email: email, password: password)
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
    
    func navigateToForgotPassword() {
        router.navigateToForgotPassword()
    }
    
    func navigateToSignup() {
        router.navigateToSignup()
    }

}
