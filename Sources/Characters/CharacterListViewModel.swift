//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import Foundation
import APIClient
import SharedModels
import OrderedCollections

public class CharacterListViewModel: ObservableObject {
    enum SortSegments: String, CaseIterable {
        case name = "Name"
        case recents = "Recents"
    }

    let apiClient: APIClient
    @Published var characters: OrderedSet<MarvelCharacter> = []
    let limit: Int
    var offset: Int
    var orderBy: OrderBy
    var isFetchInProgress = false
    let sortSegments = SortSegments.allCases.map{ $0.rawValue }

    public init(apiClient: APIClient = APIClientLive(), limit: Int = 20, offset: Int = 0, orderBy: OrderBy = .name) {
        self.apiClient = apiClient
        self.limit = limit
        self.offset = offset
        self.orderBy = orderBy
    }

    var currentCount: Int {
        return characters.count
    }

    func onViewDidLoad() async {
        await fetchCharacters()
    }

    func refresh() async {
        offset = 0
        await fetchCharacters()
    }

    func fetchCharacters() async {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true
        do {
            print("Fetching offset", offset)
            let characters = try await apiClient.marvelCharacters(limit: limit, offset: offset, orderBy: orderBy)
            addNewCharactersInSortedOrderAndUpdateOffset(characters)
        } catch {
            // handle error here
            print(error)
        }

        isFetchInProgress = false
    }

    func fetchAdditionalCharactersIfNeeded(for indexPaths: [IndexPath]) async {
        guard indexPaths.contains(where: { $0.row >= currentCount - 5 }) else { return }
        await fetchCharacters()
    }

    func onSegmentChanged(_ selectedSegment: Int) {
        if selectedSegment == 0 {
            orderBy = .name
        } else {
            orderBy = .modified
        }
        offset = 0
        sortCharacters()
    }

    private func addNewCharactersInSortedOrderAndUpdateOffset(_ characters: [MarvelCharacter]) {
        //TODO: Use the right algorithm to implement this.
        var currentOffset = 0
        for character in characters {
            let (inserted, _) = self.characters.append(character)
            if inserted {
                currentOffset += 1
            }
        }
        print("only", currentOffset, "inserted")
        self.offset += currentOffset
        sortCharacters()
    }

    func sortCharacters() {
        characters.sort(by: {
            if orderBy == .name {
                return $0.name < $1.name
            } else {
                return $0.modified ?? Date() < $1.modified ?? Date()
            }
        })
    }
}
