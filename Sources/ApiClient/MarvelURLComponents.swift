//
//  File 2.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import Foundation
import CryptoKit

public enum OrderBy: String {
    case name
    case modified
    case startDate
}

struct MarvelURLComponents {

    private let scheme = "https"
    private let host = "gateway.marvel.com"
    private let port = 443
    private let publicKey = "b541b6928d72da4a5d9f6c3fe6c9a505"
    private let privateKey = "965592cc0da2b8705bb6659a572fc2c632b35418"
    private let path: String
    private var limit: Int
    private var offset: Int
    private var orderBy: OrderBy?
    private var nameStartsWith: String?

    private var queryItems: [URLQueryItem] {
        let timeStamp = "\(Date().timeIntervalSince1970)"
        var queryItems: [URLQueryItem] =  [
            .init(name: "ts", value: timeStamp),
            .init(name: "apikey", value: publicKey),
            .init(name: "hash", value: hash(for: timeStamp + privateKey + publicKey)),
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset)),
        ]

        if let orderBy = orderBy {
            queryItems.append(.init(name: "orderBy", value: orderBy.rawValue))
        }

        if let nameStartsWith = nameStartsWith {
            queryItems.append(.init(name: "nameStartsWith", value: nameStartsWith))
        }
        
        return queryItems
    }

    private func url(for path: String) -> URL?  {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    private func hash(for string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    var urlForCharacters: URL? {
        url(for: path)
    }

    public init(path: String, nameStartsWith: String? = nil, limit: Int = 20, offset: Int = 0, orderBy: OrderBy? = nil) {
        self.path = path
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
        self.orderBy = orderBy
    }
}
