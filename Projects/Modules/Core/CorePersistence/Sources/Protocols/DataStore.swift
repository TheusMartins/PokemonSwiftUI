//
//  DataStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// A small key-value storage abstraction.
///
/// This is intentionally minimal: it helps keep higher layers decoupled from
/// the concrete persistence mechanism (filesystem, user defaults, database, etc.).
public protocol DataStore: Sendable {
    /// Returns raw data for the given key.
    func data(forKey key: String) async throws -> Data?

    /// Persists raw data for the given key.
    /// Passing `nil` removes the stored value.
    func set(_ data: Data?, forKey key: String) async throws

    /// Removes the stored value for the given key.
    func remove(forKey key: String) async throws

    /// Removes all persisted values managed by this store.
    func removeAll() async throws
}
