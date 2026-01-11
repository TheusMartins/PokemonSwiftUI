//
//  PokemonDetailsViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation

@MainActor
final class PokemonDetailsViewModel: ObservableObject {
    private let repository: PokemonDetailsRepository
    private let pokemonName: String

    @Published private(set) var model: PokemonDetailsModel?
    @Published var state: State = .idle

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    init(
        pokemonName: String,
        repository: PokemonDetailsRepository = PokemonDetailsRepositoryImpl()
    ) {
        self.pokemonName = pokemonName
        self.repository = repository
    }

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading

        do {
            model = try await repository.getPokemonDetails(name: pokemonName.lowercased())
            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }
}
