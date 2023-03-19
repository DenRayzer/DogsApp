//
//  Client.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import Foundation

enum ErrorResponse: String {
    case invalidEndpoint = "invalid endpoint"
}

struct ResponseData {
    let data: Data
    let statusCode: Int
}

protocol NetworkClient {
    func perform(request: Request, completion: @escaping (Result<ResponseData, Error>) -> Void)
}

class DefaultClient: NetworkClient {
    func perform(request: Request, completion: @escaping (Result<ResponseData, Error>) -> Void) {
        let session = URLSession(configuration: .default)
        guard let urlRequest = request.urlRequest?.url else {
            completion(.failure(NSError()))
            return
        }
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                return completion(.failure(NSError()))
            }
            
            let responseData = ResponseData(data: data, statusCode: response.statusCode)
            completion(.success(responseData))
        }.resume()
    }
}
