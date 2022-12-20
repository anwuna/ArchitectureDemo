import Foundation
//import APIClient

//let apiClient = APIClientLive()
//let characters = try await apiClient.marvelCharacters()
//print(characters)

//import Favorites

//let favoritesProvider = FavoritesProvider.shared
//favoritesProvider.$favorites.sink { character in
//    print("Added favorite is:", character)
//}
//print("here")

import Mocks
//
//let mockData = MockProvider.sampleEvents()
//print(mockData)

//print(ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"]!)
//print()
//let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"]
//let url = URL(string: override!)
////URL(fileURLWithPath: override!)
//print(url)

var array = [501, 599, 932, 341, 893]
let element1 = 501
let element2 = 932
let index1 = array.firstIndex(where: { $0 == element1 })!
let index2 = array.firstIndex(where: { $0 == element2 })!
array.remove(at: index2)
array.insert(element2, at: index1)
print(array)
