//
//  FacebookAuthProviderImpl.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import FacebookLogin
import FacebookCore
import FirebaseAuth
import FirebaseFirestore
import UIKit

final class FacebookAuthProviderImpl: SocialAuthProvider {
    private let db = Firestore.firestore()
    
    func signIn(from view: UIViewController) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: view) { result, error in
                if let error = error {
                    self.showAlert(on: view, message: error.localizedDescription)
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    self.showAlert(on: view, message: "User cancelled Facebook login")
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                
                guard let tokenString = AccessToken.current?.tokenString else {
                    self.showAlert(on: view, message: "Failed to get access token")
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error {
                        let nsError = error as NSError
                        if nsError.code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                            self.showAlert(on: view, message: "This email is already registered with another provider.")
                        } else {
                            self.showAlert(on: view, message: error.localizedDescription)
                        }
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let firebaseUser = authResult?.user else { return }
                    
                    let request = GraphRequest(graphPath: "me",
                                               parameters: ["fields": "id, name, email"])
                    request.start { _, result, error in
                        if let error = error {
                            self.showAlert(on: view, message: error.localizedDescription)
                            continuation.resume(throwing: error)
                            return
                        }
                        
                        var name = ""
                        var email = firebaseUser.email ?? ""
                        
                        if let userData = result as? [String: Any] {
                            name = userData["name"] as? String ?? ""
                            email = userData["email"] as? String ?? email
                        }
                        
                        let userData: [String: Any] = [
                            "name": name,
                            "email": email
                        ]
                        
                        self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
                            if let error {
                                self.showAlert(on: view, message: error.localizedDescription)
                                continuation.resume(throwing: error)
                                return
                            }
                            continuation.resume(returning: ())
                        }
                    }
                }
            }
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            LoginManager().logOut()
        } catch {
        }
    }
    
    private func showAlert(on view: UIViewController, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            view.present(alert, animated: true)
        }
    }
}
