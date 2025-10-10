//
//  ITunesModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

struct MusicResponse: Decodable {
    let results: [Track]
}

struct Track: Decodable {
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    let trackTimeMillis: Int?
    let previewUrl: String?
}

struct PodcastResponse: Decodable {
    let results: [Podcast]
}

struct Podcast: Decodable {
    let collectionId: Int?
    let collectionName: String
    let artistName: String
    let artworkUrl100: String
    let trackTimeMillis: Int?
}

struct EpisodeResponse: Decodable {
    let results: [Episode]
}

struct Episode: Decodable {
    let trackId: Int?
    let trackName: String?
    let artistName: String?
    let episodeUrl: String?
    let artworkUrl600: String?
    let trackTimeMillis: Int?
    let previewUrl: String?
    let description: String?
    let collectionName: String
}
