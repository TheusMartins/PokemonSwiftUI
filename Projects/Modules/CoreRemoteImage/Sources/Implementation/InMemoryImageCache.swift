//
//  InMemoryImageCache.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public actor InMemoryImageCache: ImageCaching {

    // MARK: - Private Properties

    private let cache = NSCache<NSString, NSData>()

    // MARK: - Initialization

    public init() {}

    // MARK: - Public Methods

    public func data(forKey key: String) async -> Data? {
        cache.object(forKey: key as NSString) as Data?
    }

    public func insert(_ data: Data?, forKey key: String) async {
        guard let data else {
            await remove(forKey: key)
            return
        }

        cache.setObject(data as NSData, forKey: key as NSString)
    }

    public func remove(forKey key: String) async {
        cache.removeObject(forKey: key as NSString)
    }

    public func removeAll() async {
        cache.removeAllObjects()
    }
}
