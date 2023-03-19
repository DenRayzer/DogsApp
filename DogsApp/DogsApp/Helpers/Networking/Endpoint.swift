//
//  Endpoint.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import Foundation

typealias Parameters = [String: String]

protocol Endpoint {
    var basePath: String { get }
    var compositePath: String { get }
    var headers: Parameters { get }
    var parameters: [URLQueryItem] { get }
}
