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
    @StateObject private var viewModel: PokemonListViewModel = .init()
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                DSLoadingView(size: 60)
            case .loaded:
                VStack() {
                    makePicker(generations: viewModel.generations)
                    makeList(pokemons: viewModel.pokemons)
                }
            case .failed(_):
                EmptyView()
            }
        }
        .background(DSColorToken.background.color)
        .task {
            await viewModel.loadIfNeeded()
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
                    label: { $0.name }
                )
                .background(DSColorToken.background.color)
            } else {
                EmptyView()
            }
        }
    }
    
    private func makeList(pokemons: [PokemonModel]) -> some View {
        List(pokemons) { pokemon in
            PokemonItemListView(url: pokemon.imageURL ?? pokemon.url, pokemonName: pokemon.name)
                .listRowBackground(DSColorToken.background.color)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(DSColorToken.background.color)
    }
}
