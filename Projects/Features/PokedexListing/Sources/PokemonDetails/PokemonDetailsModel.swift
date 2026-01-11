//
//  PokemonDetailsModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation
import SwiftUI

struct PokemonDetailsModel: Equatable, Sendable, Decodable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let stats: [PokemonStat]
    let sprites: PokemonSprites

    func statValue(_ kind: PokemonStatKind) -> Int? {
        stats.first(where: { $0.kind == kind })?.value
    }

    // MARK: - Decodable

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let decodedTypes = try container.decode([TypeEntry].self, forKey: .types)
        types = decodedTypes
            .sorted { $0.slot < $1.slot }
            .compactMap { PokemonType(rawValue: $0.type.name) }

        let decodedStats = try container.decode([StatEntry].self, forKey: .stats)
        stats = decodedStats.compactMap { entry in
            guard let kind = PokemonStatKind(rawValue: entry.stat.name) else { return nil }
            return PokemonStat(kind: kind, value: entry.baseStat)
        }

        sprites = try container.decode(PokemonSprites.self, forKey: .sprites)
    }

    // MARK: - Nested decoding helpers

    private struct TypeEntry: Decodable, Sendable {
        let slot: Int
        let type: NamedResource
    }

    private struct StatEntry: Decodable, Sendable {
        let baseStat: Int
        let stat: NamedResource

        private enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }

    private struct NamedResource: Decodable, Sendable {
        let name: String
    }
}

struct PokemonSprites: Equatable, Sendable, Decodable {
    let frontDefault: URL?
    let frontShiny: URL?

    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct PokemonStat: Equatable, Sendable {
    let kind: PokemonStatKind
    let value: Int
}

enum PokemonStatKind: String, CaseIterable, Equatable, Sendable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"

    var displayName: String {
        switch self {
        case .hp: return "HP"
        case .attack: return "Attack"
        case .defense: return "Defense"
        case .specialAttack: return "Sp. Atk"
        case .specialDefense: return "Sp. Def"
        case .speed: return "Speed"
        }
    }
}

enum PokemonType: String, CaseIterable, Equatable, Sendable, Decodable {
    case normal, fire, water, electric, grass, ice
    case fighting, poison, ground, flying, psychic, bug
    case rock, ghost, dragon, dark, steel, fairy

    var displayName: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .normal: return .gray.opacity(0.65)
        case .fire: return .red.opacity(0.85)
        case .water: return .blue.opacity(0.85)
        case .electric: return .yellow.opacity(0.85)
        case .grass: return .green.opacity(0.85)
        case .ice: return .cyan.opacity(0.85)
        case .fighting: return .orange.opacity(0.85)
        case .poison: return .purple.opacity(0.85)
        case .ground: return .brown.opacity(0.75)
        case .flying: return .indigo.opacity(0.75)
        case .psychic: return .pink.opacity(0.85)
        case .bug: return .green.opacity(0.65)
        case .rock: return .brown.opacity(0.85)
        case .ghost: return .indigo.opacity(0.85)
        case .dragon: return .teal.opacity(0.85)
        case .dark: return .black.opacity(0.75)
        case .steel: return .gray.opacity(0.85)
        case .fairy: return .pink.opacity(0.65)
        }
    }

    var secondaryColor: Color { color.opacity(0.55) }
}
