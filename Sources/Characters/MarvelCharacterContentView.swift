//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
import SharedModels
import SwiftUI
import Favorites

class MarvelCharacterContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }

    var viewModel: MarvelCharacterViewModel!

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

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    let storiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()

    lazy var favoritesButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "star")
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: favoriteButtonTapped))
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var cancellable: Cancellable?

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

    func favoriteButtonTapped(_ action: UIAction) {
        viewModel.favoritesButtonTapped()
    }

    func setup() {
        let nameDescriptionStackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        nameDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        nameDescriptionStackView.spacing = 4
        nameDescriptionStackView.axis = .vertical

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        let spacerWidthConstraint = spacer.widthAnchor.constraint(equalToConstant: CGFloat(Int16.max))
        spacerWidthConstraint.priority = .defaultLow
        spacerWidthConstraint.isActive = true

        let captionsStackView = UIStackView(arrangedSubviews: [storiesLabel, spacer, dateLabel])
        captionsStackView.translatesAutoresizingMaskIntoConstraints = false
        captionsStackView.distribution = .fill

        let topStackView = UIStackView(arrangedSubviews: [nameDescriptionStackView, favoritesButton])
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.alignment = .top

        let labelsStackView = UIStackView(arrangedSubviews: [topStackView, captionsStackView])
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8

        addSubview(thumbNailImageView)
        addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            thumbNailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            thumbNailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbNailImageView.heightAnchor.constraint(equalToConstant: 50),
            thumbNailImageView.widthAnchor.constraint(equalToConstant: 50),

            labelsStackView.leadingAnchor.constraint(equalTo: self.thumbNailImageView.trailingAnchor, constant: 8),
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),

            favoritesButton.widthAnchor.constraint(equalToConstant: 25),
            favoritesButton.heightAnchor.constraint(equalToConstant: 25),
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
        guard let configuration = configuration as? MarvelCharacterConfiguration else { return }
        let character = configuration.character
        self.viewModel = MarvelCharacterViewModel(character: character)

        nameLabel.text = character.name
        descriptionLabel.text = character.description
        storiesLabel.text = "\(character.stories.available) stories"

        dateLabel.text = character.formattedDate

        let imageString = character.thumbnail.url
        let url = URL(string: imageString)!
        thumbNailImageView.loadAsync(url)

        cancellable = viewModel.$isFavorite.sink {[weak self] isFavorite in
            self?.updateFavoritesButton(isFavorite)
        }
    }

    private func updateFavoritesButton(_ isFavorite: Bool) {
        var configuration = favoritesButton.configuration
        configuration?.image = UIImage(systemName: isFavorite ? "star.fill": "star")
        favoritesButton.configuration = configuration
    }
}

struct MarvelCharacterConfiguration: UIContentConfiguration {
    var character: MarvelCharacter

    func makeContentView() -> UIView & UIContentView {
        return MarvelCharacterContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> MarvelCharacterConfiguration {
        return self
    }
}


#if DEBUG
import UIHelpers
import Mocks

struct MarvelCharacterContentView_Previews: PreviewProvider {

    static var previews: some View {
        let mockCharacter = MockProvider.sampleCharacters().randomElement()!
        let configuration = MarvelCharacterConfiguration(character: mockCharacter)
        MarvelCharacterContentView(configuration: configuration)
            .preview
            .previewLayout(.fixed(width: 428, height: 100))
    }
}

#endif
