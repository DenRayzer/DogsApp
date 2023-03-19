//
//  BreedsListPresenter.swift
//  DogsApp
//
//  Created by Leeza on 18.03.2023.
//

import UIKit

typealias BreedInfo = (name: String, url: String?)

class BreedsListPresenter: BreedsListPresentationLogic {
    weak var viewController: BreedsListDisplayLogic?
    private let apiService: BreedsService
    private var breedsList: [(breed: BreedInfo, sub: [BreedInfo])] = []
    private var runningRequests = Set<UUID>()
    var breedsCount: Int {
        breedsList.count
    }
    
    init(apiService: BreedsService = BreedsServiceAPI()) {
        self.apiService = apiService
    }

    func breed(for index: Int) -> String {
        breedsList[index].breed.name
    }

    func subBreads(for index: Int) -> [BreedInfo] {
        breedsList[index].sub
    }
    
    func prepareBreedsListData() {
        apiService.getAllBreedsList { [weak self] result in
            switch result {
            case .success(let data):
                self?.breedsList = data.breeds.map { (($0, nil), $1.map { ($0, nil) }) }
                DispatchQueue.main.async {
                    self?.viewController?.displayBreedsList()
                }
            case .failure:
                self?.viewController?.displayAlert(with: Constants.Strings.fetchError)
            }
        }
    }
    
    func prepareBreedImage(breed: Int, completion: @escaping (UIImage) -> Void) -> UUID {
        let uuid = UUID()
        runningRequests.insert(uuid)
        
        if let url = breedsList[breed].breed.url {
            apiService.getImageForURL(str: url) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let image):
                    if self.runningRequests.contains(uuid) {
                        completion(image)
                    }
                case .failure:
                    break
                }
            }
        } else {
            apiService.getRandomImage(for: breedsList[breed].breed.name, subBreed: nil) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.breedsList[breed].breed.url = data.url
                    if self.runningRequests.contains(uuid) {
                        completion(data.image)
                    }
                case .failure:
                    break
                }
            }
        }
        return uuid
    }
    
    func prepareSubBreedImage(breed: Int, sub: Int, completion: @escaping (UIImage) -> Void) -> UUID {
        let uuid = UUID()
        runningRequests.insert(uuid)
        
        if let url = breedsList[breed].sub[sub].url {
            apiService.getImageForURL(str: url) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let image):
                    if self.runningRequests.contains(uuid) {
                        completion(image)
                    }
                case .failure:
                    break
                }
            }
        } else {
            apiService.getRandomImage(for: breedsList[breed].breed.name, subBreed: breedsList[breed].sub[sub].name) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.breedsList[breed].sub[sub].url = data.url
                    if self.runningRequests.contains(uuid) {
                        completion(data.image)
                    }
                case .failure:
                    break
                }
            }
        }
        return uuid
    }
    
    func cancelRequest(id: UUID) {
        runningRequests.remove(id)
    }
}
