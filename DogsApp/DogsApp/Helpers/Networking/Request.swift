//
//  Request.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import Foundation

struct Request {

    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }

    var urlRequest: URLRequest?

    init(
        endpoint: Endpoint,
        method: HTTPMethod = .GET,
        parameters: Parameters? = nil,
        body: Data? = nil
    ) {
        guard var components = URLComponents(string: endpoint.compositePath),
              let url = components.url else {
            urlRequest = nil
            return
        }
        components.queryItems = endpoint.parameters
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.allHTTPHeaderFields = endpoint.headers
    }
}

