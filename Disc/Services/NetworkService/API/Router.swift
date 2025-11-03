//
//  Router.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

protocol NetworkRouter {
    associatedtype Endpoint: EndPointType
    func request<T: Decodable>(_ route: Endpoint) async throws -> T
}

final class Router<EndPoint: EndPointType>: NetworkRouter {
    typealias Endpoint = EndPoint
    
    func request<T: Decodable>(_ route: Endpoint) async throws -> T {
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(from: route)
            let (data, response) = try await session.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            
            if (200..<300).contains(statusCode) {
                let model = try JSONDecoder().decode(T.self, from: data)
                return model
            } else {
                if let networkError = try? JSONDecoder().decode(NetworkError.self, from: data) {
                    throw networkError
                } else {
                    throw NSError(domain: "NetworkError", code: statusCode, userInfo: nil)
                }
            }
        } catch {
            throw error
        }
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        let fullURL = route.baseUrl.appendingPathComponent(route.path)
        var request = URLRequest(url: fullURL)
        request.httpMethod = route.httpMethod.rawValue
        route.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch route.task {
        case .plainRequest:
            break
        case .requestWithURL(let params):
            if let params = params {
                var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false)
                components?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            }
        case .requestWithBody(let params):
            if let params = params {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            }
        }
        return request
    }
}
