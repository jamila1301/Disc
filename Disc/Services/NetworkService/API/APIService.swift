//
//  APIService.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

protocol ITunesAPIService {
    func fetchMusic(term: String, limit: Int) async throws -> MusicResponse
    func fetchPodcast(term: String, limit: Int) async throws -> PodcastResponse
    func fetchEpisode(collectionId: Int) async throws -> EpisodeResponse
}

final class URLSessionITunesAdapter: ITunesAPIService {
    
    private let router = Router<ITunesEndPoint>()
    
    func fetchMusic(term: String, limit: Int) async throws -> MusicResponse {
        return try await router.request(.fetchMusic(term: term, limit: limit))
    }
    
    func fetchPodcast(term: String, limit: Int) async throws -> PodcastResponse {
        return try await router.request(.fetchPodcast(term: term, limit: limit))
    }
    
    func fetchEpisode(collectionId: Int) async throws -> EpisodeResponse {
        return try await router.request(.fetchEpisode(collectionId: collectionId))
    }
}
