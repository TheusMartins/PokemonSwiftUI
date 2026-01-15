//
//  JSONStoring.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

/// High-level abstraction for storing and retrieving JSON-encoded values.
public protocol JSONStoring: Sendable {

    /// Encodes and stores a value for the given key.
    func set<T: Encodable>(_ value: T, for key: PersistenceKey) async throws

    /// Retrieves and decodes a value of the given type for the key.
    func get<T: Decodable>(_ type: T.Type, for key: PersistenceKey) async throws -> T?

    /// Removes the value associated with the key.
    func remove(for key: PersistenceKey) async throws
}
