//
//  AccountViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 29.10.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AccountViewModel {
    
    private let db = Firestore.firestore()
    private var profileListener: ListenerRegistration?
    
    var onProfileImageURLUpdate: ((String?) -> Void)?
    var onError: ((String) -> Void)?
    
    func startListeningProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        profileListener?.remove()
        profileListener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                
                if let error = error {
                    self.onError?(error.localizedDescription)
                    self.onProfileImageURLUpdate?(nil)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.onProfileImageURLUpdate?(nil)
                    return
                }
                
                if let url = data["profileImageURL"] as? String, !url.isEmpty {
                    self.onProfileImageURLUpdate?(url)
                    return
                }
                
                if let photoURL = Auth.auth().currentUser?.photoURL?.absoluteString, !photoURL.isEmpty {
                    self.onProfileImageURLUpdate?(photoURL)
                    return
                }
                
                self.onProfileImageURLUpdate?(nil)
            }
    }
    
    func uploadProfileImage(_ image: UIImage) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let urlString = try await DIContainer.shared.storageManager.uploadProfileImage(image, for: uid)
            
            try await db.collection("users").document(uid).updateData([
                "profileImageURL": urlString
            ])
            
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.photoURL = URL(string: urlString)
                try await changeRequest.commitChanges()
            }
            
            onProfileImageURLUpdate?(urlString)
            
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    func removeListener() {
        profileListener?.remove()
    }
}
