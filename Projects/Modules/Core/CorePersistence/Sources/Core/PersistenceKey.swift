//
//  PersistenceKey.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

/// Strongly typed key for persistence.
/// Use static keys to avoid typos.
public struct PersistenceKey: Hashable, Sendable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Common keys

public extension PersistenceKey {
    static let pokemonTeam = PersistenceKey("pokemonTeam")
}
