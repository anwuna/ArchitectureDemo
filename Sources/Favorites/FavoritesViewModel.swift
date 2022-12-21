//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-16.
//

import Foundation
import SharedModels
import Combine

public class FavoritesViewModel: ObservableObject {
    @Published var favorites: [MarvelCharacter] = []
    var provider: FavoritesProvider

    public init(provider: FavoritesProvider = FavoritesProvider.shared) {
        self.provider = provider
        provider.$favorites.assign(to: &$favorites)
    }

    func deleteFavorite(_ character: MarvelCharacter) {
        provider.remove(id: character.id)
    }

    func reorderFavorites(sourceIndex: IndexPath, destinationIndex: IndexPath) {
        let character = provider.favorites[sourceIndex.row]
        // done delibrately to avoid applying the snapshot multiple times( i.e one for remove and one for insert) to the tableview.
        var tempFavorites = provider.favorites
        tempFavorites.remove(at: sourceIndex.row)
        tempFavorites.insert(character, at: destinationIndex.row)

        provider.favorites = tempFavorites
    }
}
