//
//  TeamPokemonStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 13/01/26.
//

import Foundation

public enum TeamPokemonStoreError: Error, Equatable, Sendable {
    case teamIsFull(max: Int)
    case alreadyExists
}

public protocol TeamPokemonStore: Sendable {
    func fetchTeam() async throws -> [TeamPokemon]
    func save(_ pokemon: TeamPokemon) async throws
    func delete(memberId: Int) async throws
    func contains(memberId: Int) async throws -> Bool
}

public final class TeamPokemonStoreImplementation: TeamPokemonStore {

    private let keyValueStore: KeyValueStoring
    private let coder: JSONCoding
    private let key: PersistenceKey
    private let maxTeamSize: Int

    private init(
        keyValueStore: KeyValueStoring,
        coder: JSONCoding,
        key: PersistenceKey,
        maxTeamSize: Int
    ) {
        self.keyValueStore = keyValueStore
        self.coder = coder
        self.key = key
        self.maxTeamSize = maxTeamSize
    }

    // ✅ Default factory for the app
    public static func makeDefault(
        directory: PersistenceDirectory = .caches,
        maxTeamSize: Int = 6
    ) async throws -> TeamPokemonStoreImplementation {
        let store = try await FileKeyValueStore(directory: directory)

        return TeamPokemonStoreImplementation(
            keyValueStore: store,
            coder: DefaultJSONCoder(),
            key: .pokemonTeam,
            maxTeamSize: maxTeamSize
        )
    }
    
    static func make(
        keyValueStore: KeyValueStoring,
        coder: JSONCoding = DefaultJSONCoder(),
        key: PersistenceKey = .pokemonTeam,
        maxTeamSize: Int = 6
    ) -> TeamPokemonStoreImplementation {
        TeamPokemonStoreImplementation(
            keyValueStore: keyValueStore,
            coder: coder,
            key: key,
            maxTeamSize: maxTeamSize
        )
    }

    public func fetchTeam() async throws -> [TeamPokemon] {
        guard let data = try await keyValueStore.get(for: key) else { return [] }
        return try coder.decode([TeamPokemon].self, from: data)
    }

    public func save(_ pokemon: TeamPokemon) async throws {
        var current = try await fetchTeam()

        if current.contains(where: { $0.id == pokemon.id }) {
            throw TeamPokemonStoreError.alreadyExists
        }

        if current.count >= maxTeamSize {
            throw TeamPokemonStoreError.teamIsFull(max: maxTeamSize)
        }

        current.append(pokemon)

        let data = try coder.encode(current)
        try await keyValueStore.set(data, for: key)
    }

    public func delete(memberId: Int) async throws {
        let current = try await fetchTeam()
        let updated = current.filter { $0.id != memberId }
        let data = try coder.encode(updated)
        try await keyValueStore.set(data, for: key)
    }

    public func contains(memberId: Int) async throws -> Bool {
        let current = try await fetchTeam()
        return current.contains(where: { $0.id == memberId })
    }
}
