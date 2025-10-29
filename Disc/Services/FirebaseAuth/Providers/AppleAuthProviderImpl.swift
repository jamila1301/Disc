//
//  AppleAuthProviderImpl.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

final class AppleAuthProviderImpl: NSObject, SocialAuthProvider {
    
    private var currentNonce: String?
    private let db = Firestore.firestore()
    private var continuation: CheckedContinuation<Void, Error>?
    
    func signIn(from view: UIViewController) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            
            self.continuation = continuation
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Apple sign out error: \(error.localizedDescription)")
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleAuthProviderImpl: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootWindow = windowScene.windows.first else {
            print("")
            return UIWindow()
        }
        return rootWindow
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                let fullName = [
                    appleIDCredential.fullName?.givenName ?? "",
                    appleIDCredential.fullName?.familyName ?? ""
                ].joined(separator: " ").trimmingCharacters(in: .whitespaces)
                
                if let firebaseUser = authResult?.user {
                    let userData: [String: Any] = [
                        "name": fullName,
                        "email": firebaseUser.email ?? ""
                    ]
                    
                    self.db.collection("users").document(firebaseUser.uid).setData(userData, merge: true) { error in
                        if let error {
                            print("Firestore error: \(error.localizedDescription)")
                            return
                        }
                    }
                }
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
}
