//
//  PokemonListView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation
import SwiftUI
import CoreDesignSystem

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    let onPokemonSelected: (String) -> Void
    @Binding var searchText: String
    let usesTabSearch: Bool

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                DSLoadingView(size: DSIconSize.huge.value)

            case .loaded:
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

            case .failed(let errorMessage):
                DSErrorScreenView(title: errorMessage) {
                    Task { await viewModel.loadIfNeeded() }
                }
            }
        }
        .background(DSColorToken.background.color)
        .task {
            await viewModel.loadIfNeeded()
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.searchText = newValue
        }
    }

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
            } else {
                EmptyView()
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
