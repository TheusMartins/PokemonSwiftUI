//
//  PokemonDetailsViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation
import CorePersistence

@MainActor
final class PokemonDetailsViewModel: ObservableObject {
    private let repository: PokemonDetailsRepository
    private let pokemonName: String
    private let teamStore: TeamPokemonStore

    @Published private(set) var model: PokemonDetailsModel?
    @Published var state: State = .idle

    @Published private(set) var isInTeam: Bool = false
    @Published private(set) var isTeamActionInProgress: Bool = false
    @Published var teamErrorMessage: String? // ou um enum se preferir

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    init(
        pokemonName: String,
        repository: PokemonDetailsRepository = PokemonDetailsRepositoryImpl(),
        teamStore: TeamPokemonStore
    ) {
        self.pokemonName = pokemonName
        self.repository = repository
        self.teamStore = teamStore
    }

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading

        do {
            let details = try await repository.getPokemonDetails(name: pokemonName.lowercased())
            model = details

            isInTeam = try await teamStore.contains(memberId: details.id)

            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }

    func toggleTeamMembership() async {
        guard let model else { return }

        isTeamActionInProgress = true
        defer { isTeamActionInProgress = false }

        do {
            if isInTeam {
                try await teamStore.delete(memberId: model.id)
                isInTeam = false
            } else {
                try await teamStore.save(model.asTeamPokemon())
                isInTeam = true
            }

            teamErrorMessage = nil
        } catch let error as TeamPokemonStoreError {
            switch error {
            case .alreadyExists:
                teamErrorMessage = "This Pokémon is already in your team."
                isInTeam = true
            case .teamIsFull(let max):
                teamErrorMessage = "Your team is full (max \(max))."
            }
        } catch {
            teamErrorMessage = "Something went wrong."
        }
    }
}

extension PokemonDetailsModel {
    func asTeamPokemon() -> TeamPokemon {
        TeamPokemon(
            id: id,
            name: name,
            spriteURL: sprites.frontDefault,
            types: types.compactMap { TeamPokemonType(rawValue: $0.rawValue) },
            stats: stats.compactMap { stat in
                guard let kind = TeamPokemonStatKind(rawValue: stat.kind.rawValue) else { return nil }
                return TeamPokemonStat(kind: kind, value: stat.value)
            }
        )
    }
}
