//
//  KeyValueStoring.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

/// Low-level abstraction for storing raw data by key.
public protocol KeyValueStoring: Sendable {

    /// Stores raw data for the given key.
    func set(_ data: Data, for key: PersistenceKey) async throws

    /// Retrieves raw data for the given key, if it exists.
    func get(for key: PersistenceKey) async throws -> Data?

    /// Removes the value associated with the key.
    func remove(for key: PersistenceKey) async throws

    /// Removes all stored values.
    func removeAll() async throws
}
