//
//  BreedsListProtocols.swift
//  DogsApp
//
//  Created by Leeza on 14.03.2023.
//

import UIKit

protocol BreedsListDisplayLogic: AnyObject {
    func displayBreedsList()
    func displayAlert(with title: String)
}

protocol BreedsListPresentationLogic {
    func prepareBreedsListData()
    func prepareBreedImage(breed: Int, completion: @escaping (UIImage) -> Void) -> UUID
    func prepareSubBreedImage(breed: Int, sub: Int, completion: @escaping (UIImage) -> Void) -> UUID
    func cancelRequest(id: UUID)
    func subBreads(for index: Int) -> [BreedInfo]
    func breed(for index: Int) -> String
    var breedsCount: Int { get }
}
