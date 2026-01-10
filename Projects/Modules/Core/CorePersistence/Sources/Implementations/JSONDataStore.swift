//
//  JSONDataStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public final class JSONDataStore {
    private let store: DataStore
    private let coder: JSONCoding
    private let dateProvider: DateProviding

    public init(
        store: DataStore,
        coder: JSONCoding = JSONCoder(),
        dateProvider: DateProviding = SystemDateProvider()
    ) {
        self.store = store
        self.coder = coder
        self.dateProvider = dateProvider
    }

    public func save<T: Encodable>(_ value: T, for key: PersistenceKey) async throws {
        let payload = Payload(savedAt: dateProvider.now(), data: try coder.encode(value))
        let encoded = try coder.encode(payload)
        try await store.save(encoded, for: key)
    }

    public func load<T: Decodable>(
        _ type: T.Type,
        for key: PersistenceKey,
        cachePolicy: CachePolicy = .never
    ) async throws -> T? {
        guard let encoded = try await store.load(for: key) else { return nil }

        let payload = try coder.decode(Payload.self, from: encoded)

        if cachePolicy.isExpired(savedAt: payload.savedAt, now: dateProvider.now()) {
            try await store.remove(for: key)
            return nil
        }

        return try coder.decode(type, from: payload.data)
    }

    public func remove(for key: PersistenceKey) async throws {
        try await store.remove(for: key)
    }

    public func removeAll() async throws {
        try await store.removeAll()
    }

    private struct Payload: Codable, Equatable {
        let savedAt: Date
        let data: Data
    }
}
