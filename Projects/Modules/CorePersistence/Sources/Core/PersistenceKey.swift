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

    // MARK: - Properties

    public let rawValue: String

    // MARK: - Initialization

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Common Keys

public extension PersistenceKey {

    /// Stores the user's Pokémon team.
    static let pokemonTeam = PersistenceKey("pokemonTeam")
}
