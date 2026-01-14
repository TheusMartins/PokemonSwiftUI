//
//  DefaultJSONStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public final class DefaultJSONStore: JSONStoring {
    private let store: KeyValueStoring
    private let coder: JSONCoding

    public init(
        store: KeyValueStoring,
        coder: JSONCoding = DefaultJSONCoder()
    ) {
        self.store = store
        self.coder = coder
    }

    public func set<T: Encodable>(_ value: T, for key: PersistenceKey) async throws {
        let data = try coder.encode(value)
        try await store.set(data, for: key)
    }

    public func get<T: Decodable>(_ type: T.Type, for key: PersistenceKey) async throws -> T? {
        guard let data = try await store.get(for: key) else { return nil }
        return try coder.decode(type, from: data)
    }

    public func remove(for key: PersistenceKey) async throws {
        try await store.remove(for: key)
    }
}
