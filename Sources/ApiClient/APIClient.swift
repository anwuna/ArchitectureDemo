//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import Foundation
import SharedModels

public protocol APIClient {
    func marvelCharacters(limit: Int, offset: Int, orderBy: OrderBy?) async throws -> [MarvelCharacter]
    func marvelEvents(nameStartsWith: String?, limit: Int, offset: Int, orderBy: OrderBy?) async throws -> [Event]
}

enum APIError: Error {
    case invalidURL
    case decodingError
}

enum DateError: String, Error {
    case invalidDate
}

public struct APIClientLive: APIClient {
    public init() {}

    public func marvelCharacters(limit: Int = 20, offset: Int = 0, orderBy: OrderBy? = nil) async throws -> [MarvelCharacter] {
        let result: CharacterDataWrapper = try await fetchData(path: "/v1/public/characters", nameStartsWith: nil, limit: limit, offset: offset, orderBy: orderBy)
        return result.data.results
    }

    public func marvelEvents(nameStartsWith: String? = nil, limit: Int, offset: Int, orderBy: OrderBy?) async throws -> [Event] {
        let result: EventDataWrapper = try await fetchData(path: "/v1/public/events", nameStartsWith: nameStartsWith, limit: limit, offset: offset, orderBy: orderBy)
        return result.data.results
    }

    public func fetchData<T: Decodable>(path: String, nameStartsWith: String? = nil, limit: Int, offset: Int, orderBy: OrderBy?) async throws -> T {
        guard let url = MarvelURLComponents(path: path, limit: limit, offset: offset, orderBy: orderBy).urlForCharacters else {
            throw APIError.invalidURL
        }

        let (data, _ ) = try await URLSession.shared.data(from: url)
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(customDateDecodingStartegy)
            // print(String(data: data, encoding: .utf8))

            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }

    var customDateDecodingStartegy: @Sendable (Decoder) throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return { (decoder) throws -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            print("Invalid date", dateStr)
            throw DateError.invalidDate
        }
    }
}
