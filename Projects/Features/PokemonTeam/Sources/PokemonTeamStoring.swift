//
//  PokemonTeamStoring.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation
import CorePersistence

public protocol PokemonTeamStoring: Sendable {
    func fetchTeam() async throws -> [TeamPokemon]
    func delete(memberId: Int) async throws
}

public final class DefaultPokemonTeamStore: PokemonTeamStoring {

    private let keyValueStore: KeyValueStoring
    private let coder: JSONCoding
    private let key: PersistenceKey

    public init(
        keyValueStore: KeyValueStoring,
        coder: JSONCoding = DefaultJSONCoder(),
        key: PersistenceKey = .pokemonTeam
    ) {
        self.keyValueStore = keyValueStore
        self.coder = coder
        self.key = key
    }

    public func fetchTeam() async throws -> [TeamPokemon] {
        guard let data = try await keyValueStore.get(for: key) else { return [] }
        return try coder.decode([TeamPokemon].self, from: data)
    }

    public func delete(memberId: Int) async throws {
        let current = try await fetchTeam()
        let updated = current.filter { $0.id != memberId }
        let data = try coder.encode(updated)
        try await keyValueStore.set(data, for: key)
    }
}
