//
//  KeyValueStoring.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//


import Foundation

public protocol KeyValueStoring: Sendable {
    func set(_ data: Data, for key: PersistenceKey) async throws
    func get(for key: PersistenceKey) async throws -> Data?
    func remove(for key: PersistenceKey) async throws
    func removeAll() async throws
}
