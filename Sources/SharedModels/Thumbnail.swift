//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

// MARK: - Thumbnail
public struct Thumbnail: Codable, Hashable {
    public let path: String
    public let thumbnailExtension: Extension

    public init(path: String, thumbnailExtension: Extension) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

extension Thumbnail {
    public var url: String {
        path + "." + thumbnailExtension.rawValue
    }
}

public enum Extension: String, Codable, Hashable {
    case gif
    case jpg
    case png
}
