//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation
import Combine
import APIClient
import SharedModels

import Mocks

public class EventsViewModel: ObservableObject {
    let apiClient: APIClient
    @Published var events: [Event] = []
    var nameStartsWith: String?
    let limit: Int
    var offset: Int
    var orderBy: OrderBy
    var isFetchInProgress = false

    public init(apiClient: APIClient = APIClientLive(), limit: Int = 20, offset: Int = 0, orderBy: OrderBy = .name) {
        self.apiClient = apiClient
        self.limit = limit
        self.offset = offset
        self.orderBy = orderBy
    }

    var currentCount: Int {
        return events.count
    }

    func onViewDidLoad() async {
//        let sampleEvents = MockProvider.sampleEvents()
//        events = sampleEvents
        await fetchEvents()
    }

    func fetchEvents() async {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true
        do {
            print("Fetching offset", offset)
            let events = try await apiClient.marvelEvents(nameStartsWith: nameStartsWith, limit: limit, offset: offset, orderBy: orderBy)
            if !events.isEmpty {
                updateOffset()
            }
            self.events.append(contentsOf: events)
        } catch {
            // handle error here
            print(error)
        }

        isFetchInProgress = false
    }

    func fetchAdditionalEventsIfNeeded(for indexPaths: [IndexPath]) async {
        guard indexPaths.contains(where: { $0.row >= currentCount - 5 }) else { return }
        await fetchEvents()
    }

    private func updateOffset() {
        offset += limit
    }
}
