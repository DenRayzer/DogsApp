//
//  DogsServiceApi.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import UIKit

protocol BreedsService {
    func getAllBreedsList(completion: @escaping (Result<BreedsListModel, BreedsServiceError>) -> Void)
    func getRandomImage(for breed: String, subBreed: String?, completion: @escaping (Result<(image: UIImage, url: String), Error>) -> Void)
    func getImageForURL(str: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class BreedsServiceAPI: BreedsService {
    private let client: NetworkClient
    private let imageClient: LoadImageClient
    
    init(
        client: NetworkClient = DefaultClient(),
        imageClient: LoadImageClient = LoadImageDefaultClient()
    ) {
        self.client = client
        self.imageClient = imageClient
    }
    
    func getImageForURL(str: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        _ = imageClient.loadImage(str) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRandomImage(for breed: String, subBreed: String?, completion: @escaping (Result<(image: UIImage, url: String), Error>) -> Void) {
        let request: Request
        
        if let subBreed = subBreed {
            request = Request(
                endpoint: BreedsServiceAPI.DogsServiceEndpoint.randomImgForSubBreed(breed: breed, subBreed: subBreed)
            )
        } else {
            request = Request(
                endpoint: BreedsServiceAPI.DogsServiceEndpoint.randomImgForBreed(breed: breed)
            )
        }
        
        _ = client.perform(request: request) { [weak self] request in
            switch request {
            case .success(let response):
                do {
                    let imgURL = try JSONDecoder().decode(BreedImageModel.self, from: response.data).imgURL
                    
                    let _ = self?.imageClient.loadImage(imgURL) { result in
                        switch result {
                        case .success(let image):
                            completion(.success((image, imgURL)))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } catch let error as NSError {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllBreedsList(completion: @escaping (Result<BreedsListModel, BreedsServiceError>) -> Void) {
        let request = Request(endpoint: BreedsServiceAPI.DogsServiceEndpoint.allBreeds)
        
        _ = client.perform(request: request) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200...299:
                    do {
                        let breedsList = try JSONDecoder().decode(BreedsListModel.self, from: response.data)
                        completion(.success(breedsList))
                    } catch let error as NSError {
                        completion(
                            .failure(
                                .serverError(
                                    response: .init(
                                        code: error.code,
                                        message: error.localizedDescription
                                    )
                                )
                            )
                        )
                    }
                default:
                    guard let errorResponse = try? JSONDecoder().decode(
                        BreedsServiceError.ServerErrorResponse.self,
                        from: response.data
                    ) else {
                        completion(.failure(.decodeError))
                        return
                    }
                    completion(.failure(.serverError(response: errorResponse)))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
