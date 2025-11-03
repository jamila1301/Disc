//
//  ITunesEndPoint.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

enum ITunesEndPoint {
    case fetchMusic(term: String, limit: Int)
    case fetchPodcast(term: String, limit: Int)
    case fetchEpisode(collectionId: Int)
}

extension ITunesEndPoint: EndPointType {
    var baseUrl: URL {
        return URL(string: "https://itunes.apple.com/")!
    }
    
    var path: String {
        switch self {
        case .fetchMusic, .fetchPodcast:
            return "search"
        case .fetchEpisode:
            return "lookup"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchMusic(let term, let limit):
            return .requestWithURL(params: ["term": term, "entity": "musicTrack", "limit": limit])
        case .fetchPodcast(let term, let limit):
            return .requestWithURL(params: ["term": term, "entity": "podcast", "limit": limit])
        case .fetchEpisode(let collectionId):
            return .requestWithURL(params: ["id": collectionId, "entity": "podcastEpisode"])
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
