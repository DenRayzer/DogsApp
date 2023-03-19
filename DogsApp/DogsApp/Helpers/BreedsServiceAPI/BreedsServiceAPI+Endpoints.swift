//
//  BreedsServiceAPI+Endpoints.swift
//  DogsApp
//
//  Created by Leeza on 18.03.2023.
//

import Foundation

extension BreedsServiceAPI {
    enum DogsServiceEndpoint: Endpoint {
        var parameters: [URLQueryItem] { [] }

        case allBreeds
        case randomImgForBreed(breed: String)
        case allImgForBreed(breed: String)
        case allImgSubBreed(breed: String, subBreed: String)
        case randomImgForSubBreed(breed: String, subBreed: String)

        var basePath: String {
            "https://dog.ceo/api"
        }
        private var rawValue: String {
            switch self {
            case .allBreeds:
                return "breeds/list/all"
            case .randomImgForBreed(let breed):
                return "breed/\(breed)/images/random"
            case .allImgForBreed(let breed):
                return "breed/\(breed)/images"
            case .allImgSubBreed(let breed, let subBreed):
                return "breed/\(breed)/\(subBreed)/images"
            case .randomImgForSubBreed(let breed, let subBreed):
                return "breed/\(breed)/\(subBreed)/images/random"
            }
        }
        var compositePath: String {
            "\(basePath)/\(rawValue)"
        }

        var headers: Parameters { [:] }
    }
}
