//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import SharedModels
@_exported import Combine

public class FavoritesProvider: ObservableObject {
    @Published public var favorites: [MarvelCharacter] = []
    public static var shared = FavoritesProvider()

    init() {}

    public func add(character: MarvelCharacter) {
        favorites.append(character)
    }

    public func remove(id: MarvelCharacter.ID) {
        favorites.removeAll(where: { $0.id == id })
    }
}
