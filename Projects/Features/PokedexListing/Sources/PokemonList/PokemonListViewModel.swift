//
//  PokemonListViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

final class PokemonListViewModel {
    private let repository: PokemonListRepository
    private var selectedGeneration: Int = 1
    
    @Published var state: PokemonListViewModel.State = .idle
    
    enum State {
        case idle
        case loading
        case didLoad(generationModel: [GenerationModel], pokemonModel: [PokemonModel])
        case didLoadNewGeneration(pokemonModel: [PokemonModel])
        case didFailOnLoad(feedbackMessage: String)
    }
    
    init(repository: PokemonListRepository = PokemonListRepositoryImpl()) {
        self.repository = repository
    }
    
    func getPokemons() async {
        state = .loading
        do {
            let generation = try await repository.getGenerations()
            let pokemonGeneration = try await repository.getPokemon(generationId: selectedGeneration)
            
            await MainActor.run {
                self.state = .didLoad(generationModel: generation.results, pokemonModel: pokemonGeneration.results)
            }
        } catch {
            state = .didFailOnLoad(feedbackMessage: "Something went wrong")
        }
    }
    
    func changeGeneration(id: Int) async {
        state = .loading
        selectedGeneration = id
        do {
            let pokemonGeneration = try await repository.getPokemon(generationId: selectedGeneration)
            await MainActor.run {
                self.state = .didLoadNewGeneration(pokemonModel: pokemonGeneration.results)
            }
        } catch {
            state = .didFailOnLoad(feedbackMessage: "Something went wrong")
        }
    }
}
