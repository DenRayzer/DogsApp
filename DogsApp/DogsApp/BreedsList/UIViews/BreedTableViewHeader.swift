//
//  BreedTableViewCell.swift
//  DogsApp
//
//  Created by Leeza on 13.03.2023.
//

import UIKit

fileprivate struct LocalConstants {
    static let stackViewSpacing: CGFloat = 20
    static let imageHeight: CGFloat = 180
    static let padding: CGFloat = 20
}

class BreedTableViewHeader: UITableViewHeaderFooterView {
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = LocalConstants.stackViewSpacing
        stackView.axis = .vertical
        
        return stackView
    }()
    private var dogImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.UI.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray

        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: LocalConstants.imageHeight)
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([heightConstraint])
        
        return imageView
    }()
    private var titleLabel: UILabel = UILabel()
    var onReuse: () -> Void = {}
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

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

    func configureUI() {
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.useAndActivateConstraints([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  LocalConstants.padding),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  LocalConstants.padding),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -LocalConstants.padding),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -LocalConstants.padding),
        ])

        contentStackView.addArrangedSubview(dogImageView)
        contentStackView.addArrangedSubview(titleLabel)
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
