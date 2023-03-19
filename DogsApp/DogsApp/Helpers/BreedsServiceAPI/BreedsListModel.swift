//
//  BreedModel.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import Foundation

typealias Breed = String
typealias BreedsList = [Breed: [Breed]]

struct BreedsListModel: Decodable {
    var breeds: BreedsList

    enum CodingKeys: String, CodingKey {
        case breeds = "message"
    }
}

struct BreedImageModel: Decodable {
    var imgURL: String

    enum CodingKeys: String, CodingKey {
        case imgURL = "message"
    }
}
