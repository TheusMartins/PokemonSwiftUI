//
//  JSONStoring.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public protocol JSONStoring: Sendable {
    func set<T: Encodable>(_ value: T, for key: PersistenceKey) async throws
    func get<T: Decodable>(_ type: T.Type, for key: PersistenceKey) async throws -> T?
    func remove(for key: PersistenceKey) async throws
}
