//
//  PokemonTeamViewModel.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation
import CorePersistence

@MainActor
final class PokemonTeamViewModel: ObservableObject {

    // MARK: - Types

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    // MARK: - Published properties

    @Published private(set) var members: [TeamPokemon] = []
    @Published var state: State = .idle

    // MARK: - Private properties

    private let store: TeamPokemonStore

    // MARK: - Initialization

    init(store: TeamPokemonStore) {
        self.store = store
    }

    // MARK: - Factory (async)

    static func makeDefault() async throws -> PokemonTeamViewModel {
        let store = try await TeamPokemonStoreImplementation.makeDefault()
        return PokemonTeamViewModel(store: store)
    }

    // MARK: - Public methods

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading

        do {
            members = try await store.fetchTeam()
            state = .loaded
        } catch {
            state = .failed(message: .genericErrorMessage)
        }
    }

    func delete(memberId: Int) async {
        do {
            try await store.delete(memberId: memberId)
            members = try await store.fetchTeam()
            state = .loaded
        } catch {
            state = .failed(message: .genericErrorMessage)
        }
    }
}

// MARK: - Strings

private extension String {
    static let genericErrorMessage = "Something went wrong"
}
