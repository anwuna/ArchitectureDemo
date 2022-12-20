//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

// MARK: - CharacterDataWrapper
public struct CharacterDataWrapper: Codable {
    public let code: Int
    public let status, copyright, attributionText, attributionHTML: String
    public let etag: String
    public let data: CharacterDataContainer
}

// MARK: - CharacterDataContainer
public struct CharacterDataContainer: Codable {
    public let offset, limit, total, count: Int
    public let results: [MarvelCharacter]
}
