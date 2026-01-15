//
//  PokemonListView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation
import SwiftUI
import CoreDesignSystem

// MARK: - View

struct PokemonListView: View {

    // MARK: - Dependencies

    @ObservedObject var viewModel: PokemonListViewModel
    let onPokemonSelected: (String) -> Void
    @Binding var searchText: String
    let usesTabSearch: Bool

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                DSLoadingView(size: DSIconSize.huge.value)

            case .loaded:
                content

            case .failed(let errorMessage):
                DSErrorScreenView(title: errorMessage) {
                    Task { await viewModel.loadIfNeeded() }
                }
            }
        }
        .background(DSColorToken.background.color)
        .task {
            await viewModel.loadIfNeeded()
            await viewModel.applyGenerationFromContextIfNeeded()
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.searchText = newValue
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack {
            makePicker(generations: viewModel.generations)

            if !usesTabSearch {
                DSSearchBar(
                    text: $searchText,
                    placeholder: "Search Pokémon"
                )
                .padding(.horizontal, DSSpacing.xLarge.value)
            }

            makeList(pokemons: viewModel.filteredPokemons)
        }
    }

    // MARK: - Components

    private func makePicker(generations: [GenerationModel]) -> some View {
        Group {
            if let selected = viewModel.selectedGeneration {
                DSPicker(
                    options: generations,
                    selection: Binding(
                        get: { selected },
                        set: { newValue in
                            viewModel.selectedGeneration = newValue
                            Task { await viewModel.changeGeneration(to: newValue) }
                        }
                    ),
                    label: { $0.name.capitalized }
                )
                .background(DSColorToken.background.color)
            }
        }
    }

    private func makeList(pokemons: [PokemonModel]) -> some View {
        List(pokemons) { pokemon in
            Button {
                onPokemonSelected(pokemon.name)
            } label: {
                PokemonItemListView(
                    url: pokemon.imageURL ?? pokemon.url,
                    pokemonName: pokemon.name.capitalized
                )
            }
            .buttonStyle(.plain)
            .listRowBackground(DSColorToken.background.color)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(DSColorToken.background.color)
    }
}
