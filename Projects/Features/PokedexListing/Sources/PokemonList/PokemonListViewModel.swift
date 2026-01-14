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
    private let searchContext: PokedexListingSearchContext

    @Published var selectedGeneration: GenerationModel?
    @Published private(set) var generations: [GenerationModel] = []
    @Published private(set) var pokemons: [PokemonModel] = []
    @Published var state: State = .idle
    @Published var searchText: String = ""
    
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    init(
        repository: PokemonListRepository = PokemonListRepositoryImpl(),
        searchContext: PokedexListingSearchContext
    ) {
        self.repository = repository
        self.searchContext = searchContext
    }
    
    // MARK: - Derived
    
    var filteredPokemons: [PokemonModel] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return pokemons }
        
        return pokemons.filter { pokemon in
            pokemon.name.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Loading
    
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }
    
    func load() async {
        state = .loading
        do {
            let generationsResponse = try await repository.getGenerations()
            generations = generationsResponse.results

            // Pick from context if available, otherwise first
            if let id = searchContext.selectedGenerationId,
               let match = generations.first(where: { $0.name == id }) {
                selectedGeneration = match
            } else {
                selectedGeneration = generations.first
                searchContext.selectedGenerationId = selectedGeneration?.name
            }

            if let generation = selectedGeneration {
                pokemons = try await repository.getPokemon(generationId: generation.name).results
            }

            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }
    
    func changeGeneration(to generation: GenerationModel) async {
        selectedGeneration = generation
        searchContext.selectedGenerationId = generation.name

        let id = generation.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !id.isEmpty else {
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
    
    func applyGenerationFromContextIfNeeded() async {
        guard state == .loaded else { return }
        guard let id = searchContext.selectedGenerationId else { return }
        guard selectedGeneration?.name != id else { return }
        guard let newGen = generations.first(where: { $0.name == id }) else { return }

        await changeGeneration(to: newGen)
    }
}
