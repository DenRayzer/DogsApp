//
//  ViewController.swift
//  DogsApp
//
//  Created by Leeza on 06.03.2023.
//

import UIKit

class BreedsListViewController: UIViewController {
    
    private var tableView = UITableView(frame: .zero, style: .grouped)
    var presenter: BreedsListPresentationLogic

    init(presenter: BreedsListPresentationLogic) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.prepareBreedsListData()

        configure()
    }
    
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 200
        tableView.backgroundColor = .clear

        setUpNavigationBar()
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none

        tableView.register(SubBreedTableViewCell.self, forCellReuseIdentifier: Constants.IDs.breedTableViewCellReusableId)
        tableView.register(BreedTableViewHeader.self, forHeaderFooterViewReuseIdentifier: Constants.IDs.breedTableViewHeaderReusableId)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        NSLayoutConstraint.useAndActivateConstraints(constraints)
    }
    
    private func setUpNavigationBar() {
        view.backgroundColor = .white
        let favourites = UIBarButtonItem(image: UIImage.init(systemName: Constants.ImageNames.heart), style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = favourites
        navigationItem.title = Constants.Strings.breedsTitle
    }

    @objc
    func addTapped() {
        displayAlert(with: Constants.Strings.favouritesTappedTitle)
    }
}

extension BreedsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.subBreads(for: section).count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.breedsCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.IDs.breedTableViewHeaderReusableId) as! BreedTableViewHeader
        view.setTitle(with: presenter.breed(for: section))

        let requestId = presenter.prepareBreedImage(breed: section) { image in
            DispatchQueue.main.async {
                view.setImage(image: image)
            }
        }
        
        view.configureCell(with: { self.presenter.cancelRequest(id: requestId) })
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDs.breedTableViewCellReusableId, for: indexPath) as! SubBreedTableViewCell
        let subcells = presenter.subBreads(for: indexPath.section)[indexPath.row]
        cell.setTitle(with: subcells.name)
    
        let requestId = presenter.prepareSubBreedImage(breed: indexPath.section, sub: indexPath.row) { image in
            DispatchQueue.main.async {
                cell.setImage(image: image)
            }
        }

        cell.configureCell(with: { self.presenter.cancelRequest(id: requestId) })
        return cell
    }
}

extension BreedsListViewController: BreedsListDisplayLogic {
    func displayAlert(with title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.okButton, style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func displayBreedsList() {
        tableView.reloadData()
    }
    
}
