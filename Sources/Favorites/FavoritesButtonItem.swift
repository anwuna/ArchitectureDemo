//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import UIKit
import Combine

public class FavoritesButtonItem: UIBarButtonItem {
    private var cancellables = [AnyCancellable]()

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .orange
        return label
    }()

    public override init() {
        super.init()
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        FavoritesProvider.shared
            .$favorites
            .sink { [weak self] newFavorites in
                self?.label.text = "\(newFavorites.count)"
            }
            .store(in: &cancellables)

        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.tintColor = .orange

        let stackView = UIStackView(arrangedSubviews: [label, starImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4

        customView = stackView
    }
}
