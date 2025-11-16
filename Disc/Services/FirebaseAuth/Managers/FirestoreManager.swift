//
//  FirestoreManager.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    private let db = Firestore.firestore()
    
    func saveLikedMusic(userId: String, track: Track) async throws {
        let data: [String: Any] = [
            "trackName": track.trackName,
            "artistName": track.artistName,
            "artworkUrl100": track.artworkUrl100,
            "previewUrl": track.previewUrl ?? "",
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("likedMusics")
            .document(UUID().uuidString)
            .setData(data)
    }
    
    func saveLikedEpisode(userId: String, episode: Episode) async throws {
        let data: [String: Any] = [
            "trackName": episode.trackName,
            "artistName": episode.artistName ?? "",
            "artworkUrl600": episode.artworkUrl600,
            "previewUrl": episode.previewUrl ?? "",
            "collectionName": episode.collectionName,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("likedEpisodes")
            .document(UUID().uuidString)
            .setData(data)
    }
    
    func removeLikedMusic(userId: String, track: Track) async throws {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("likedMusics")
            .whereField("trackName", isEqualTo: track.trackName)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }

    
    func removeLikedEpisode(userId: String, episode: Episode) async throws {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("likedEpisodes")
            .whereField("trackName", isEqualTo: episode.trackName)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    func fetchLikedMusics(userId: String) async throws -> [LikedMusicTableViewCell.Item] {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("likedMusics")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            guard let trackName = data["trackName"] as? String,
                  let artistName = data["artistName"] as? String,
                  let artworkUrl100 = data["artworkUrl100"] as? String else {
                return nil
            }
            return LikedMusicTableViewCell.Item(
                image: artworkUrl100,
                musicName: trackName,
                artistName: artistName,
                previewUrl: data["previewUrl"] as? String
            )
        }
    }
    
    func fetchLikedEpisodes(userId: String) async throws -> [LikedEpisodeTableViewCell.Item] {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("likedEpisodes")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            guard let trackName = data["trackName"] as? String,
                  let artistName = data["artistName"] as? String,
                  let artworkUrl600 = data["artworkUrl600"] as? String,
                  let collectionName = data["collectionName"] as? String else {
                return nil
            }
            return LikedEpisodeTableViewCell.Item(
                image: artworkUrl600,
                episodeName: trackName,
                artistName: artistName,
                previewUrl: data["previewUrl"] as? String,
                collectionName: collectionName
            )
        }
    }
}
