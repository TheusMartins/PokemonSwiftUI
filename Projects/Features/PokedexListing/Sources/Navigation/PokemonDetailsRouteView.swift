//
//  PokemonDetailsRouteView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI
import CoreDesignSystem
import CorePersistence

public struct PokemonDetailsRouteView: View {

    private let pokemonName: String

    @StateObject private var builder = Builder()

    public init(pokemonName: String) {
        self.pokemonName = pokemonName
    }

    public var body: some View {
        Group {
            switch builder.state {
            case .idle, .loading:
                DSLoadingView(size: DSIconSize.huge.value)

            case .failed:
                DSErrorScreenView {
                    Task { await builder.build(pokemonName: pokemonName) }
                }

            case .ready(let viewModel):
                PokemonDetailsView(viewModel: viewModel)
            }
        }
        .task {
            await builder.buildIfNeeded(pokemonName: pokemonName)
        }
    }
}

private extension PokemonDetailsRouteView {

    @MainActor
    final class Builder: ObservableObject {

        enum State {
            case idle
            case loading
            case failed
            case ready(PokemonDetailsViewModel)
        }

        @Published private(set) var state: State = .idle

        func buildIfNeeded(pokemonName: String) async {
            guard case .idle = state else { return }
            await build(pokemonName: pokemonName)
        }

        func build(pokemonName: String) async {
            state = .loading
            do {
                let store = try await TeamPokemonStoreImplementation.makeDefault()
                let viewModel = PokemonDetailsViewModel(
                    pokemonName: pokemonName,
                    teamStore: store
                )
                state = .ready(viewModel)
            } catch {
                state = .failed
            }
        }
    }
}
