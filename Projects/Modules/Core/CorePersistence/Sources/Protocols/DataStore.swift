//
//  DataStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// High-level persistence API used by features.
/// Actor-friendly: async operations.
public protocol DataStore: Sendable {
    func save(_ data: Data, for key: PersistenceKey) async throws
    func load(for key: PersistenceKey) async throws -> Data?
    func remove(for key: PersistenceKey) async throws
    func removeAll() async throws
}
