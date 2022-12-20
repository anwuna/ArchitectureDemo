//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import Combine
import Foundation
import Favorites
import SharedModels

class CharacterDetailViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    let provider: FavoritesProvider
    let character: MarvelCharacter
    var cancellable: Cancellable?

    init(character: MarvelCharacter, provider: FavoritesProvider = FavoritesProvider.shared) {
        self.character = character
        self.provider = provider

        cancellable = provider.$favorites.sink { favorites in
            self.isFavorite = favorites.contains(where: { $0 == character })
        }
    }

    var eventsString: String {
        let items = character.events.items
        let count = items.count > 5 ? 5 : items.count
        var events: [String] = (0..<count).map { items[$0].name }
        if count < items.count {
            events.append(" ... ")
        }
        return events.joined(separator: ", ")
    }

    func favoritesButtonTapped() {
        if isFavorite {
            provider.remove(id: character.id)
        } else {
            provider.add(character: character)
        }
    }

    var favoritesRank: String {
        let rank = provider.favorites.firstIndex(where: { $0 == character })
        guard let rank = rank else {
            return "\(character.name) has not been added to Favorites"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let rankString = formatter.string(from: NSNumber(value: rank + 1)) ?? ""
        return "\(character.name) is the \(rankString) favorite"
    }
}
