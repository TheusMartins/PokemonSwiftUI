//
//  ImageCaching.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Abstraction responsible for caching image data.
public protocol ImageCaching: Sendable {

    /// Returns cached data for the given key.
    func data(forKey key: String) async -> Data?

    /// Inserts data into the cache for the given key.
    func insert(_ data: Data?, forKey key: String) async

    /// Removes cached data for the given key.
    func remove(forKey key: String) async

    /// Clears all cached data.
    func removeAll() async
}
