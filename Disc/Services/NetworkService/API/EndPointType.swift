//
//  EndPointType.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

protocol EndPointType {
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [String: String]? { get }
}

extension EndPointType {
    var baseUrl: URL {
        return URL(string: "https://itunes.apple.com/")!
    }
}

enum HTTPTask {
    case plainRequest
    case requestWithURL(params: [String: Any]?)
    case requestWithBody(params: [String: Any]?)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
