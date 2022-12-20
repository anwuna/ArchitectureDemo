//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

// MARK: - Stories
public struct StoryList: Codable, Hashable {
    public let available: Int
    public let collectionURI: String
    public let items: [StoriesItem]
    public let returned: Int

    public init(available: Int, collectionURI: String, items: [StoriesItem], returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }
}

// MARK: - StoriesItem
public struct StoriesItem: Codable, Hashable {
    let resourceURI: String
    let name: String
    let type: ItemType

    public init(resourceURI: String, name: String, type: ItemType) {
        self.resourceURI = resourceURI
        self.name = name
        self.type = type
    }
}
