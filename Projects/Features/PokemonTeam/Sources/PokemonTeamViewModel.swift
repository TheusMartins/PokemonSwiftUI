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

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    @Published private(set) var members: [TeamPokemon] = []
    @Published var state: State = .idle

    private let store: PokemonTeamStoring

    init(store: PokemonTeamStoring) {
        self.store = store
    }

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
            state = .failed(message: "Something went wrong")
        }
    }

    func delete(memberId: Int) async {
        do {
            try await store.delete(memberId: memberId)
            members = try await store.fetchTeam()
            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }
}
