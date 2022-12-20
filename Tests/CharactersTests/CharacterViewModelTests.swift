//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import XCTest
import APIClient
import SharedModels

@testable import Characters

final class CharactersViewModelTests: XCTestCase {
    let mockCharacter = MarvelCharacter(id: 1, name: "Thor", description: "Thor", modified: Date(), thumbnail: Thumbnail(path: "", thumbnailExtension: .jpg), resourceURI: "", comics: ComicList(available: 1, collectionURI: "", items: [], returned: 0), series: ComicList(available: 0, collectionURI: "", items: [], returned: 1), stories: StoryList(available: 0, collectionURI: "", items: [], returned: 0), events: ComicList(available: 0, collectionURI: "", items: [], returned: 0), urls: [])

    func testFetchCharactersOnViewDidLoad() async {
        let limit = 5
        let mockAPIClient = MockAPIClient(characters: mockCharacter)
        let sut = CharacterListViewModel(apiClient: mockAPIClient, limit: limit)
        await sut.onViewDidLoad()
        XCTAssertEqual(sut.currentCount, 5)
    }

    func testUpdateOffsetAfterOnViewDidLoadCalled() async {
        let limit = 5
        let mockAPIClient = MockAPIClient(characters: mockCharacter)
        let sut = CharacterListViewModel(apiClient: mockAPIClient, limit: limit)
        XCTAssertEqual(sut.offset, 0)
        await sut.onViewDidLoad()
        XCTAssertEqual(sut.offset, 5)
        await sut.fetchCharacters()
        XCTAssertEqual(sut.offset, 10)
    }

    func testfetchAdditionalCharactersIfNeeded() async {
        let limit = 2
        let mockAPIClient = MockAPIClient(characters: mockCharacter)
        let sut = CharacterListViewModel(apiClient: mockAPIClient, limit: limit)
        await sut.onViewDidLoad()
        XCTAssertEqual(sut.currentCount, 2)
        let indexPaths = [IndexPath(row: 2, section: 1), IndexPath(row: 3, section: 1)]
        await sut.fetchAdditionalCharactersIfNeeded(for: indexPaths)
        XCTAssertEqual(sut.currentCount, 4)
    }

    func testShouldNotFetchIfAlreadyFetching() async {
        let limit = 2
        let mockAPIClient = MockAPIClient(characters: mockCharacter, delay: 1)
        let sut = CharacterListViewModel(apiClient: mockAPIClient, limit: limit)
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<2 {
                group.addTask {
                    await sut.fetchCharacters()
                }
            }
            await group.waitForAll()
        }

        XCTAssertEqual(sut.currentCount, 2)
    }
}

struct MockAPIClient: APIClient {
    let characters: MarvelCharacter
    var delay: TimeInterval = 0

    func marvelCharacters(limit: Int, offset: Int, orderBy: OrderBy?) async throws -> [SharedModels.MarvelCharacter] {
        try await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
        return (0..<limit).map { _ in characters }
    }

    func marvelEvents(nameStartsWith: String?, limit: Int, offset: Int, orderBy: OrderBy?) async throws -> [SharedModels.Event] {
        []
    }


}

