//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import UIKit
import SharedModels
import Combine

class CharacterDetailViewController: UIViewController {
    struct Constant {
        static let imageWidth: CGFloat = 50
    }

    var cancellable: Cancellable?
    let viewModel: CharacterDetailViewModel

    lazy var favoritesButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "star")
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: favoriteButtonTapped))
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }

    func setup() {
        setupNavigationBar()
        setupView()
        setupBinding()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: dismiss))
    }

    func setupView() {
        let thumbNailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = Constant.imageWidth / 2
            let imageString = viewModel.character.thumbnail.url
            let url = URL(string: imageString)!
            imageView.loadAsync(url)
            return imageView
        }()

        let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .title1)
            label.text = viewModel.character.name
            return label
        }()

        let dateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .preferredFont(forTextStyle: .caption2)
            label.text = viewModel.character.formattedDate
            return label
        }()

        let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8

        let headerStackView = UIStackView(arrangedSubviews: [thumbNailImageView, labelsStackView])
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.spacing = 8
        headerStackView.alignment = .center


        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .body)
            label.text = viewModel.character.description
            return label
        }()

        let favoritesRankButton: UIButton = {
            var configuration = UIButton.Configuration.borderedProminent()
            configuration.title = "Show Rank"
            let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: favoritesRankButtonTapped))
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        let buttonsStackView = UIStackView(arrangedSubviews: [favoritesRankButton, favoritesButton])
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 8

        let eventsCountLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .body).with(.traitBold)
            label.text = "Events (\(viewModel.character.events.available))"
            return label
        }()

        let eventsLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = .preferredFont(forTextStyle: .caption1).italic
            label.text = viewModel.eventsString
            return label
        }()

        let eventsStackView = UIStackView(arrangedSubviews: [eventsCountLabel, eventsLabel])
        eventsStackView.translatesAutoresizingMaskIntoConstraints = false
        eventsStackView.spacing = 8
        eventsStackView.axis = .vertical

        let bodyStackView = UIStackView(arrangedSubviews: [descriptionLabel, buttonsStackView, eventsStackView])
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 32

        let contentStackView = UIStackView(arrangedSubviews: [headerStackView, bodyStackView])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 40

        view.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            thumbNailImageView.widthAnchor.constraint(equalToConstant: Constant.imageWidth),
            thumbNailImageView.heightAnchor.constraint(equalTo: thumbNailImageView.widthAnchor),

            contentStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

    private func setupBinding() {
        cancellable = viewModel.$isFavorite.sink {[weak self] isFavorite in
            self?.updateFavoritesButton(isFavorite)
        }
    }

    private func updateFavoritesButton(_ isFavorite: Bool) {
        var configuration = favoritesButton.configuration
        configuration?.image = UIImage(systemName: isFavorite ? "star.fill": "star")
        favoritesButton.configuration = configuration
    }

    func favoriteButtonTapped(_ action: UIAction) {
        viewModel.favoritesButtonTapped()
    }

    func favoritesRankButtonTapped(_ action :UIAction) {
        let alert = UIAlertController(title: "Favorite Rank", message: viewModel.favoritesRank, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func dismiss(_ action: UIAction) {
        self.dismiss(animated: true)
    }

}


#if DEBUG
import UIHelpers
import Mocks

struct CharacterDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let mockCharacter = MockProvider.sampleCharacters()[1]
        let viewModel = CharacterDetailViewModel(character: mockCharacter)
        let vc = UINavigationController(rootViewController: CharacterDetailViewController(viewModel: viewModel))
        return vc.preview
    }
}

#endif
