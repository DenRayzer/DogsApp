//
//  SubBreedTableViewCell.swift
//  DogsApp
//
//  Created by Leeza on 13.03.2023.
//

import UIKit

fileprivate struct LocalConstants {
    static let imageHeight: CGFloat = 20
    static let leadingPadding: CGFloat = 30
    static let trailingPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 14
    static let spacing: CGFloat = 20
}

class SubBreedTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    private let dogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.UI.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    var onReuse: () -> Void = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dogImageView.image = nil
        onReuse()
    }
    
    private func configureUI() {
        selectionStyle = .none
        contentView.addSubview(dogImageView)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dogImageView.widthAnchor.constraint(equalToConstant: LocalConstants.imageHeight),
            dogImageView.heightAnchor.constraint(equalToConstant: LocalConstants.imageHeight),
            dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  LocalConstants.leadingPadding),
            dogImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -LocalConstants.bottomPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dogImageView.trailingAnchor, constant:  LocalConstants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -LocalConstants.trailingPadding)
        ])
    }
    
    func setTitle(with title: String) {
        titleLabel.text = title
    }
    
    func configureCell(with onReuse: @escaping () -> Void) {
        self.onReuse = onReuse
    }
    
    func setImage(image: UIImage) {
        UIView.transition(with: self.dogImageView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: { self.dogImageView.image = image },
                          completion: nil)
    }
}
