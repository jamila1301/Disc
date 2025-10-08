//
//  GoogleAuthProviderImpl.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import UIKit

final class GoogleAuthProviderImpl: SocialAuthProvider {
    private let db = Firestore.firestore()
    
    func signIn(from view: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: view)
        
        let user = result.user
        
        guard let idToken = user.idToken?.tokenString else {
            print("Google ID token not found")
            return
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        let firebaseUser = authResult.user
        
        let userData: [String: Any] = [
            "name": user.profile?.name ?? "",
            "email": firebaseUser.email ?? ""
        ]
        
        try await db.collection("users").document(firebaseUser.uid).setData(userData)
        
        let vc = HomeViewController()
        view.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch {
            print("Google sign out error: \(error.localizedDescription)")
        }
    }
}
