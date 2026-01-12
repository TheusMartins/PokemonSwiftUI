//
//  TeamPokemon.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public struct TeamPokemon: Codable, Equatable, Hashable, Sendable, Identifiable {
    public let id: Int
    public let name: String
    public let spriteURL: URL?
    public let types: [TeamPokemonType]
    public let stats: [TeamPokemonStat]

    public init(
        id: Int,
        name: String,
        spriteURL: URL?,
        types: [TeamPokemonType],
        stats: [TeamPokemonStat]
    ) {
        self.id = id
        self.name = name
        self.spriteURL = spriteURL
        self.types = types
        self.stats = stats
    }
}

// MARK: - Types

public enum TeamPokemonType: String, Codable, CaseIterable, Equatable, Hashable, Sendable, Identifiable {
    case normal, fire, water, electric, grass, ice
    case fighting, poison, ground, flying, psychic, bug
    case rock, ghost, dragon, dark, steel, fairy

    public var id: String { rawValue }
}

public struct TeamPokemonStat: Codable, Equatable, Hashable, Sendable {
    public let kind: TeamPokemonStatKind
    public let value: Int

    public init(kind: TeamPokemonStatKind, value: Int) {
        self.kind = kind
        self.value = value
    }
}

public enum TeamPokemonStatKind: String, Codable, CaseIterable, Equatable, Hashable, Sendable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"
}
