//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-10.
//

import UIKit

public protocol CacheManager {
    func object(forKey key: String) -> AnyObject?
    func set(object: AnyObject, forKey key: String)
}

public class CacheManagerLive: CacheManager {
    static let cache = NSCache<NSString, AnyObject>()
    public static let shared = CacheManagerLive()

    public func object(forKey key: String) -> AnyObject? {
        Self.cache.object(forKey: key as NSString)
    }

    public func set(object: AnyObject, forKey key: String) {
        Self.cache.setObject(object, forKey: key as NSString)
    }
}


public protocol ResourceFetcher {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: ResourceFetcher { }

public struct AsyncImageFetcher {
    let cacheManager: CacheManager
    let resourceFetcher: ResourceFetcher

    public init(
        cacheManager: CacheManager = CacheManagerLive.shared,
        resourceFetcher: ResourceFetcher = URLSession.shared
    ) {
        self.cacheManager = cacheManager
        self.resourceFetcher = resourceFetcher
    }

    public func fetchImage(from url: URL) async -> UIImage? {
        if let cachedImage = cacheManager.object(forKey: url.absoluteString) as? UIImage {
            return cachedImage
        }

        do {
            let (data, _) = try await resourceFetcher.data(from: url)
            if let image = UIImage(data: data) {
                cacheManager.set(object: image, forKey: url.absoluteString)
                return image
            }
        } catch {
            print("Failed to fetch image", error)
        }

        return nil
    }
}
