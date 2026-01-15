//
//  PokemonListViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    // MARK: - Published properties

    @Published var selectedGeneration: GenerationModel?
    @Published private(set) var generations: [GenerationModel] = []
    @Published private(set) var pokemons: [PokemonModel] = []
    @Published var state: State = .idle
    @Published var searchText: String = ""

    // MARK: - Private properties

    private let repository: PokemonListRepository
    private let searchContext: PokedexListingSearchContext
    private var observeTask: Task<Void, Never>?

    // MARK: - Initialization

    init(
        repository: PokemonListRepository = PokemonListRepositoryImpl(),
        searchContext: PokedexListingSearchContext
    ) {
        self.repository = repository
        self.searchContext = searchContext
        observeSearchContextChanges()
    }

    deinit {
        observeTask?.cancel()
    }

    // MARK: - Derived

    var filteredPokemons: [PokemonModel] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return pokemons }

        return pokemons.filter { $0.name.localizedCaseInsensitiveContains(query) }
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

            selectedGeneration = pickInitialGeneration(from: generations)

            if let generation = selectedGeneration {
                pokemons = try await repository.getPokemon(generationId: generation.name).results
            }

            state = .loaded
        } catch {
            state = .failed(message: .somethingWentWrong)
        }
    }

    // MARK: - Generation

    func changeGeneration(to generation: GenerationModel) async {
        selectedGeneration = generation
        searchContext.selectedGenerationId = generation.name

        let id = generation.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !id.isEmpty else {
            state = .failed(message: .invalidGenerationId)
            return
        }

        do {
            pokemons = try await repository.getPokemon(generationId: id).results
            state = .loaded
        } catch {
            state = .failed(message: .somethingWentWrong)
        }
    }

    func applyGenerationFromContextIfNeeded() async {
        guard state == .loaded else { return }
        guard let id = searchContext.selectedGenerationId else { return }
        guard selectedGeneration?.name != id else { return }
        guard let newGen = generations.first(where: { $0.name == id }) else { return }

        await changeGeneration(to: newGen)
    }

    // MARK: - Helpers

    private func observeSearchContextChanges() {
        observeTask = Task { [weak self] in
            guard let self else { return }
            for await _ in searchContext.$selectedGenerationId.values {
                await self.applyGenerationFromContextIfNeeded()
            }
        }
    }

    private func pickInitialGeneration(from generations: [GenerationModel]) -> GenerationModel? {
        if let id = searchContext.selectedGenerationId,
           let match = generations.first(where: { $0.name == id }) {
            return match
        }

        let first = generations.first
        searchContext.selectedGenerationId = first?.name
        return first
    }
}

// MARK: - Strings

private extension String {
    static let somethingWentWrong = "Something went wrong"
    static let invalidGenerationId = "Invalid generation id"
}
