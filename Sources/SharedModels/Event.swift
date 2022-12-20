//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

// MARK: - Result
public struct Event: Codable, Hashable {
    public let id: Int
    public let title, description: String
    public let resourceURI: String
    public let urls: [URLElement]
    public let modified: Date
    public let start, end: String?
    public let thumbnail: Thumbnail
    public let creators: Creators
    public let characters: Characters
    public let stories: StoryList
    public let comics, series: Characters
    public let next, previous: Next?
}

// MARK: - Characters
public struct Characters: Codable, Hashable {
    public let available: Int
    public let collectionURI: String
    public let items: [Next]
    public let returned: Int
}

// MARK: - Next
public struct Next: Codable, Hashable {
    public let resourceURI: String
    public let name: String
}

// MARK: - Creators
public struct Creators: Codable, Hashable {
    public let available: Int
    public let collectionURI: String
    public let items: [CreatorsItem]
    public let returned: Int
}

// MARK: - CreatorsItem
public struct CreatorsItem: Codable, Hashable {
    let resourceURI: String
    let name: String
    let role: Role
}

public enum Role: String, Codable, Hashable {
    case artist = "artist"
    case colorist = "colorist"
    case coloristCover = "colorist (cover)"
    case editor = "editor"
    case inker = "inker"
    case inkerCover = "inker (cover)"
    case letterer = "letterer"
    case other = "other"
    case penciler = "penciler"
    case pencilerCover = "penciler (cover)"
    case penciller = "penciller"
    case pencillerCover = "penciller (cover)"
    case roleColorist = "Colorist"
    case roleLetterer = "Letterer"
    case rolePenciller = "Penciller"
    case writer = "writer"
}
