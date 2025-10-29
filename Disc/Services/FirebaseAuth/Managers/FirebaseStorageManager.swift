//
//  FirebaseStorageManager.swift
//  Disc
//
//  Created by Jamila Mahammadli on 28.10.25.
//

import UIKit
import FirebaseStorage

final class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storageRef = Storage.storage().reference()
    
    private init() {}
    
    func uploadProfileImage(_ image: UIImage, for userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        let imageRef = storageRef.child("profileImages/\(userId).jpg")
        
        _ = try await imageRef.putDataAsync(imageData)
        
        let downloadURL = try await imageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
}
