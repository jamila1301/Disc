//
//  ForgotPasswordViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import Foundation

protocol ForgotPasswordViewModelProtocol {
    func sendPasswordReset(email: String) async throws
}

final class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    private let authManager = FirebaseAuthManagerImpl()
    private var router: ForgotPasswordRouterProtocol
    
    init(router: ForgotPasswordRouterProtocol) {
        self.router = router
    }
    
    func sendPasswordReset(email: String) async throws {
        try await authManager.sendPasswordReset(email: email)
        await MainActor.run {
            router.showResetSuccess()
        }
    }
}
