import Foundation

// MARK: - Character
public struct MarvelCharacter: Codable, Hashable {
    public struct ID: Codable, RawRepresentable, Hashable {
        public var rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let name: String
    public let description: String
    public let modified: Date?
    public let thumbnail: Thumbnail
    public let resourceURI: String
    public let comics, series: ComicList
    public let stories: StoryList
    public let events: ComicList
    public let urls: [URLElement]

    public init(id: ID, name: String, description: String, modified: Date?, thumbnail: Thumbnail, resourceURI: String, comics: ComicList, series: ComicList, stories: StoryList, events: ComicList, urls: [URLElement]) {
        self.id = id
        self.name = name
        self.description = description
        self.modified = modified
        self.thumbnail = thumbnail
        self.resourceURI = resourceURI
        self.comics = comics
        self.series = series
        self.stories = stories
        self.events = events
        self.urls = urls
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(ID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.modified = try container.decodeIfPresent(Date.self, forKey: .modified)
        self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        self.resourceURI = try container.decode(String.self, forKey: .resourceURI)
        self.comics = try container.decode(ComicList.self, forKey: .comics)
        self.series = try container.decode(ComicList.self, forKey: .series)
        self.stories = try container.decode(StoryList.self, forKey: .stories)
        self.events = try container.decode(ComicList.self, forKey: .events)
        self.urls = try container.decode([URLElement].self, forKey: .urls)
    }
}


extension MarvelCharacter {
    public var formattedDate: String {
        guard modified != nil else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        return formatter.string(for: modified!) ?? ""
    }
}

// MARK: - MarvelCharacter.ID
extension MarvelCharacter.ID: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(rawValue: RawValue(integerLiteral: value))
    }
}

// MARK: - ComicList
public struct ComicList: Codable, Hashable {
    public let available: Int
    public let collectionURI: String
    public let items: [ComicsItem]
    public let returned: Int

    public init(available: Int, collectionURI: String, items: [ComicsItem], returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }
}

// MARK: - ComicsItem
public struct ComicsItem: Codable, Hashable {
    public let resourceURI: String
    public let name: String

    public init(resourceURI: String, name: String) {
        self.resourceURI = resourceURI
        self.name = name
    }
}
