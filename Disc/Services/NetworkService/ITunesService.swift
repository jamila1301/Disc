//
//  ITunesService.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

final class ITunesService {
    static let shared = ITunesService()
    private init() {}
    
    func fetchMusic(term: String, limit: Int) async throws -> [Track] {
        let query = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term
        let urlString = "https://itunes.apple.com/search?term=\(query)&entity=musicTrack&limit=\(limit)"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MusicResponse.self, from: data)
        return response.results
    }
    
    func fetchPodcast(term: String, limit: Int) async throws -> [Podcast] {
        let query = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term
        let urlString = "https://itunes.apple.com/search?term=\(query)&entity=podcast&limit=\(limit)"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PodcastResponse.self, from: data)
        return response.results
    }
    
    func fetchEpisode(for collectionId: Int) async throws -> [Episode] {
        let urlString = "https://itunes.apple.com/lookup?id=\(collectionId)&entity=podcastEpisode"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(EpisodeResponse.self, from: data)
        return Array(response.results.dropFirst())
    }
}

