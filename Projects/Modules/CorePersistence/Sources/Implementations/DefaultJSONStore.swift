//
//  DefaultJSONStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public final class DefaultJSONStore: JSONStoring {

    // MARK: - Private Properties

    private let store: KeyValueStoring
    private let coder: JSONCoding

    // MARK: - Initialization

    public init(
        store: KeyValueStoring,
        coder: JSONCoding = DefaultJSONCoder()
    ) {
        self.store = store
        self.coder = coder
    }

    // MARK: - Public Methods

    /// Encodes and persists a value for the given key.
    public func set<T: Encodable>(_ value: T, for key: PersistenceKey) async throws {
        let data = try coder.encode(value)
        try await store.set(data, for: key)
    }

    /// Retrieves and decodes a persisted value for the given key.
    /// - Returns: The decoded value, or `nil` if no value exists.
    public func get<T: Decodable>(_ type: T.Type, for key: PersistenceKey) async throws -> T? {
        guard let data = try await store.get(for: key) else { return nil }
        return try coder.decode(type, from: data)
    }

    /// Removes the persisted value for the given key.
    public func remove(for key: PersistenceKey) async throws {
        try await store.remove(for: key)
    }
}
