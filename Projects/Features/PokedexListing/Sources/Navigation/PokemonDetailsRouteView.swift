//
//  PokemonDetailsRouteView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI
import CoreDesignSystem
import CorePersistence

struct PokemonDetailsRouteView: View {

    private let pokemonName: String

    @State private var viewModel: PokemonDetailsViewModel?
    @State private var didFailBuildingDependencies: Bool = false

    init(pokemonName: String) {
        self.pokemonName = pokemonName
    }

    var body: some View {
        Group {
            if let viewModel {
                PokemonDetailsView(viewModel: viewModel)
            } else if didFailBuildingDependencies {
                DSErrorScreenView {
                    Task { await build() }
                }
            } else {
                DSLoadingView(size: DSIconSize.huge.value)
            }
        }
        .task {
            await buildIfNeeded()
        }
    }

    private func buildIfNeeded() async {
        guard viewModel == nil, !didFailBuildingDependencies else { return }
        await build()
    }

    private func build() async {
        do {
            let store = try await TeamPokemonStoreImplementation.makeDefault()
            viewModel = PokemonDetailsViewModel(
                pokemonName: pokemonName,
                teamStore: store
            )
            didFailBuildingDependencies = false
        } catch {
            didFailBuildingDependencies = true
        }
    }
}
