//
//  DogsServiceError.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import Foundation

enum BreedsServiceError: Error {
    case commonError
    case networkError
    case decodeError
    case serverError(response: ServerErrorResponse)

    struct ServerErrorResponse: Decodable {
        let code: Int
        let message: String?
    }
}
