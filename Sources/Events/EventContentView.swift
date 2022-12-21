//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-18.
//
import UIKit
import SharedModels
import SwiftUI

class EventContentView: UIView, UIContentView {
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

    let titleLabel: UILabel = {
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

    let comicsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2).italic
        return label
    }()

    let comicsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
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
        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, comicsLabel, comicsTextView])
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8

        let contentStackView = UIStackView(arrangedSubviews: [thumbNailImageView, labelsStackView])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 8
        contentStackView.alignment = .top

        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            thumbNailImageView.heightAnchor.constraint(equalToConstant: 50),
            thumbNailImageView.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbNailImageView.layer.cornerRadius = 25
        thumbNailImageView.clipsToBounds = true
    }

    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? EventContentConfiguration else { return }
        let event = configuration.event

        let imageString = event.thumbnail.url
        let url = URL(string: imageString)!
        thumbNailImageView.loadAsync(url)
        thumbNailImageView.layer.cornerRadius = thumbNailImageView.frame.size.height / 2
        thumbNailImageView.clipsToBounds = true

        titleLabel.text = event.title
        descriptionLabel.text = event.description
        comicsLabel.text = "\(event.stories.available) Comics"

        comicsTextView.attributedText = attributedComicsText(event)
    }

    private func attributedComicsText(_ event: Event) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        var comicsString: [NSAttributedString] = []
        let items = event.comics.items
        let count = items.count > 5 ? 5 : items.count
        for i in 0..<count {
            let comic = items[i]
            let str = NSAttributedString(
                string: comic.name,
                attributes: [
                    .link: comic.resourceURI,
                    .font: UIFont.systemFont(ofSize: 16),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ])
            comicsString.append(str)
        }

        for i in 0..<comicsString.count {
            attributedString.append(comicsString[i])

            if i == comicsString.count - 1 {
                attributedString.append(NSAttributedString(string: " ... "))
            } else {
                attributedString.append(NSAttributedString(string: ", "))
            }

        }
        return attributedString
    }
}

struct EventContentConfiguration: UIContentConfiguration {
    var event: Event

    func makeContentView() -> UIView & UIContentView {
        return EventContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> EventContentConfiguration {
        return self
    }
}

#if DEBUG
import SwiftUIHelpers
import Mocks

struct EventContentView_Previews: PreviewProvider {
    static var previews: some View {
        let event = MockProvider.sampleEvents().randomElement()!
        let configuration = EventContentConfiguration(event: event)
        EventContentView(configuration: configuration)
            .preview
            .previewLayout(.fixed(width: 428, height:200))
    }
}
#endif
