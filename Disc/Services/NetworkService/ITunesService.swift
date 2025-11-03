//
//  ITunesService.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

protocol ITunesNetworkServiceProtocol {
    func fetchMusic(term: String, limit: Int) async throws -> [Track]
    func fetchPodcast(term: String, limit: Int) async throws -> [Podcast]
    func fetchEpisode(collectionId: Int) async throws -> [Episode]
}

final class ITunesService: ITunesNetworkServiceProtocol {
    
    static let shared = ITunesService()
    private let apiService: ITunesAPIService = URLSessionITunesAdapter()
    
    private init() {}
    
    func fetchMusic(term: String, limit: Int) async throws -> [Track] {
        let response = try await apiService.fetchMusic(term: term, limit: limit)
        return response.results
    }
    
    func fetchPodcast(term: String, limit: Int) async throws -> [Podcast] {
        let response = try await apiService.fetchPodcast(term: term, limit: limit)
        return response.results
    }
    
    func fetchEpisode(collectionId: Int) async throws -> [Episode] {
        let response = try await apiService.fetchEpisode(collectionId: collectionId)
        return Array(response.results.dropFirst())
    }
}
