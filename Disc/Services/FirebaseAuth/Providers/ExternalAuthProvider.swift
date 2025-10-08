//
//  ExternalAuthProvider.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit

protocol EmailAuthProvider {
    func signIn(email: String, password: String) async throws
    func signUp(name: String, email: String, password: String) async throws
    func resetPassword(email: String) async throws
    func signOut() async
}

protocol SocialAuthProvider {
    func signIn(from view: UIViewController) async throws
    func signOut() async
}
