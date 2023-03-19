//
//  BreedsListAssembly.swift
//  DogsApp
//
//  Created by Leeza on 18.03.2023.
//

import UIKit

final class BreedsListAssembly {
    static func build() -> UIViewController {
        let presenter = BreedsListPresenter()
        let controller = BreedsListViewController(presenter: presenter)
        presenter.viewController = controller

        return controller
    }
}
