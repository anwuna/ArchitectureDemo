//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import UIKit
import SharedModels
import SwiftUI

class FavoriteCharacterContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }

    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
        configure(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setup() {
        let contentStackView = UIStackView(arrangedSubviews: [thumbNailImageView, nameLabel])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            thumbNailImageView.heightAnchor.constraint(equalToConstant: 50),
            thumbNailImageView.widthAnchor.constraint(equalToConstant: 50),

            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])

        let topAnchor = thumbNailImageView.topAnchor.constraint( greaterThanOrEqualTo: topAnchor, constant: 8)
        topAnchor.priority = .defaultHigh
        topAnchor.isActive = true

        let bottomAnchor = thumbNailImageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -8)
        bottomAnchor.priority = .defaultHigh
        bottomAnchor.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbNailImageView.layer.cornerRadius = thumbNailImageView.frame.size.height / 2
        thumbNailImageView.clipsToBounds = true
    }

    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? FavoriteCharacterConfiguration else { return }
        let character = configuration.character
        nameLabel.text = character.name
        let imageString = character.thumbnail.url
        let url = URL(string: imageString)!
        thumbNailImageView.loadAsync(url)
    }
}

struct FavoriteCharacterConfiguration: UIContentConfiguration {
    var character: MarvelCharacter

    func makeContentView() -> UIView & UIContentView {
        return FavoriteCharacterContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FavoriteCharacterConfiguration {
        return self
    }
}
