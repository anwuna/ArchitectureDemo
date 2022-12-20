//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-16.
//

import Foundation
import Combine
import Favorites
import SharedModels

class MarvelCharacterViewModel: ObservableObject {
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

    func favoritesButtonTapped() {
        if isFavorite {
            provider.remove(id: character.id)
        } else {
            provider.add(character: character)
        }
    }
}
