//
//  PokemonListViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {
    private let repository: PokemonListRepository
    @Published var selectedGeneration: GenerationModel?
    
    @Published private(set) var generations: [GenerationModel] = []
    @Published private(set) var pokemons: [PokemonModel] = []
    @Published var state: State = .idle
    
    enum State {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }
    
    init(repository: PokemonListRepository = PokemonListRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading
        do {
            let generationsResponse = try await repository.getGenerations()
            generations = generationsResponse.results
            selectedGeneration = generations.first

            if let generation = selectedGeneration {
                let pokemonResponse = try await repository.getPokemon(
                    generationId: generation.name
                )
                pokemons = pokemonResponse.results
            }

            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }
    
    func changeGeneration(to generation: GenerationModel) async {
        selectedGeneration = generation

        guard let id = selectedGeneration?.name else {
            state = .failed(message: "Invalid generation id")
            return
        }

        do {
            pokemons = try await repository.getPokemon(generationId: id).results
            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }
}
