//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

// MARK: - URLElement
public struct URLElement: Codable, Hashable {
    public let type: URLType
    public let url: String

    public init(type: URLType, url: String) {
        self.type = type
        self.url = url
    }
}

public enum URLType: String, Codable, Hashable {
    case comiclink
    case detail
    case wiki
}
