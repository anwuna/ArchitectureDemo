//
//  AsyncImageFetcherTests.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-10.
//

import XCTest
@testable import AsyncImage

final class AsyncImageFetcherTests: XCTestCase {

    func testShouldReturnImageFromCacheIfItExists() async {
        let mockImage = UIImage()
        let cacheManager = MockCacheManager(mockImage: mockImage)
        let resourceFetcher = MockResourceFetcher()
        let imageFetcher = AsyncImageFetcher(
            cacheManager: cacheManager,
            resourceFetcher: resourceFetcher)
        let image = await imageFetcher.fetchImage(from: URL(string: "some/path")!)
        XCTAssertEqual(mockImage, image)
    }

    func testShouldReturnNilIfImageResourceNotFound() async {
        let url = "/some/random/image.png"
        let resourceFetcher = MockResourceFetcher()
        let imageFetcher = AsyncImageFetcher(resourceFetcher: resourceFetcher)
        let image = await imageFetcher.fetchImage(from: URL(string: url)!)
        XCTAssertNil(image)
    }

    func testShouldReturnImageIfImageResourceExists() async {
        let url = "some/random/image"
        let image = UIImage(systemName: "star")
        let resourceFetcher = MockResourceFetcher(image: image)
        let imageFetcher = AsyncImageFetcher(
            cacheManager: MockCacheManager(),
            resourceFetcher: resourceFetcher)
        let fetchedImage = await imageFetcher.fetchImage(from: URL(string: url)!)
        XCTAssertNotNil(fetchedImage?.pngData())
    }

}

class MockCacheManager: CacheManager {
    let mockImage: UIImage?

    init(mockImage: UIImage? = nil) {
        self.mockImage = mockImage
    }

    func object(forKey key: String) -> AnyObject? {
        mockImage
    }

    func set(object: AnyObject, forKey key: String) {
    }
}

class MockResourceFetcher: ResourceFetcher {
    let image: UIImage?

    init(image: UIImage? = nil) {
        self.image = image
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        (image?.pngData() ?? Data(), URLResponse())
    }


}
