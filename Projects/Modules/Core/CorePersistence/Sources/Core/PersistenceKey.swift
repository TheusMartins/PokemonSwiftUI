//
//  PersistenceKey.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// A strongly-typed key used by persistence stores.
/// Prefer using `static let` keys (e.g. `.pokemonTeam`) to avoid typos.
public struct PersistenceKey: Hashable, Sendable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension PersistenceKey {
    static let pokemonTeam = PersistenceKey("pokemonTeam")
    static let pokedexListingCache = PersistenceKey("pokedexListingCache")
}
