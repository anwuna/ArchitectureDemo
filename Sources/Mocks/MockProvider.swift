//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-18.
//

import SharedModels
import Foundation

enum DateError: String, Error {
    case invalidDate
}

public struct MockProvider {
    enum MockError: Error {
        case fileNotFound
    }

    static func fetchData<T: Decodable>(filename: String) throws -> T {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else {
            throw MockError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(customDateDecodingStartegy)
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        }
    }

    static var customDateDecodingStartegy: @Sendable (Decoder) throws -> Date {
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

    public static func sampleEvents() -> [Event] {
        do {
            let result: EventDataWrapper = try fetchData(filename: "events")
            return result.data.results
        } catch {
            print(error)
            return []
        }
    }

    public static func sampleCharacters() -> [MarvelCharacter] {
        do {
            let result: CharacterDataWrapper = try fetchData(filename: "characters")
            return result.data.results
        } catch {
            print(error)
            return []
        }
    }
}
