//
//  FirebaseAuthManager.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import FirebaseFirestore
import FacebookLogin
import FacebookCore

protocol FirebaseAuthManager {
    var view: UIViewController? { get set }
    func signupWithEmail(name: String, email: String, password: String)
    func authWithMail(email: String, password: String)
    func authWithGoogle()
    func authWithApple()
    func authWithFacebook()
    func sendPasswordReset(email: String)
}

final class FirebaseAuthManagerImpl: NSObject, FirebaseAuthManager {
    
    private let db = Firestore.firestore()
    
    weak var view: UIViewController?
    
    fileprivate var currentNonce: String?
    
    func signupWithEmail(name: String, email: String, password: String) {
        guard let view else { return }
        guard !email.isEmpty, !password.isEmpty else {
            print("Email və şifrə boş ola bilməz")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            if let userId = result?.user.uid {
                self.db.collection("users").document(userId).setData([
                    "name": name,
                    "email": email
                ])
                let vc = HomeViewController()
                view.navigationController?.setViewControllers([vc], animated: true)
            }
        }
    }
    
    func authWithMail(email: String, password: String) {
        guard let view else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            let vc = HomeViewController()
            view.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func authWithGoogle() {
        guard let view else { return }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { result, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if let firebaseUser = result?.user {
                    let userData: [String: Any] = [
                        "name": user.profile?.name ?? "",
                        "email": firebaseUser.email ?? ""
                    ]
                    
                    self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
                        if let error {
                            print("Firestore error: \(error.localizedDescription)")
                            return
                        }
                        let vc = HomeViewController()
                        view.navigationController?.setViewControllers([vc], animated: true)
                    }
                }
            }
        }
    }
    
    func authWithApple() {
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
    
    func authWithFacebook() {
        guard let view else { return }
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: view) { result, error in
            if let error = error {
                print("Facebook login error: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled Facebook login")
                return
            }
            
            guard let tokenString = AccessToken.current?.tokenString else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error {
                    print("Firebase Facebook login error: \(error.localizedDescription)")
                    return
                }
                
                guard let firebaseUser = authResult?.user else { return }
                
                let request = GraphRequest(graphPath: "me",
                                           parameters: ["fields": "id, name, email"])
                request.start { _, result, error in
                    if let error = error {
                        print("GraphRequest failed: \(error.localizedDescription)")
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
                            print("Firestore error: \(error.localizedDescription)")
                            return
                        }
                        let vc = HomeViewController()
                        view.navigationController?.setViewControllers([vc], animated: true)
                    }
                }
            }
        }
    }
    
    func sendPasswordReset(email: String) {
        guard let view else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                view.present(alert, animated: true)
                return
            }
            
            let vc = PasswordResetSuccessViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            view.present(vc, animated: true)
        }
    }

    
}

extension FirebaseAuthManagerImpl: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootWindow = windowScene.windows.first else {
            print("")
            return UIWindow()
        }
        return rootWindow
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let view else { return }
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
                    
                    self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
                        if let error {
                            print("Firestore error: \(error.localizedDescription)")
                            return
                        }
                        let vc = HomeViewController()
                        view.navigationController?.setViewControllers([vc], animated: true)
                    }
                }
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
}
