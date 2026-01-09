//
//  InMemoryImageCache.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

public actor InMemoryImageCache: ImageCaching {
    private let cache = NSCache<NSString, AnyObject>()

    public init() {}

    public func image(forKey key: String) -> Image? {
        cache.object(forKey: key as NSString) as? Image
    }

    public func insert(_ image: Image?, forKey key: String) {
        guard let image else {
            remove(forKey: key)
            return
        }
        cache.setObject(image as AnyObject, forKey: key as NSString)
    }

    public func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}
