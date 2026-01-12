//
//  PokemonDetailsView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI
import CoreDesignSystem
import CoreRemoteImage

struct PokemonDetailsView: View {
    @StateObject private var viewModel: PokemonDetailsViewModel

    init(pokemonName: String) {
        _viewModel = StateObject(wrappedValue: PokemonDetailsViewModel(pokemonName: pokemonName))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                DSLoadingView(size: DSIconSize.huge.value)

            case .loading:
                DSLoadingView(size: DSIconSize.huge.value)

            case .loaded:
                makeContent()

            case .failed(let errorMessage):
                DSErrorScreenView(title: errorMessage) {
                    Task { await viewModel.loadIfNeeded() }
                }
            }
        }
        .background(DSColorToken.background.color)
        .navigationTitle(viewModel.model?.name.capitalized ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    // MARK: - Content

    private func makeContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xLarge.value) {
                makeSpritesRow()
                makeTypesSection()
                makeStatsSection()
            }
            .padding(.horizontal, DSSpacing.xLarge.value)
            .padding(.top, DSSpacing.large.value)
            .padding(.bottom, DSSpacing.huge.value)
        }
    }

    private func makeSpritesRow() -> some View {
        let frontDefault = viewModel.model?.sprites.frontDefault
        let frontShiny = viewModel.model?.sprites.frontShiny

        return HStack(spacing: DSSpacing.large.value) {
            DSRemoteImageCardView(title: "Default", url: frontDefault)
            DSRemoteImageCardView(title: "Shiny", url: frontShiny)
        }
    }

    // MARK: - Types

    @ViewBuilder
    private func makeTypesSection() -> some View {
        if let types = viewModel.model?.types, !types.isEmpty {
            VStack(alignment: .leading, spacing: DSSpacing.medium.value) {
                DSText("Types", style: .title)

                // Pokémon tem no máximo 2 tipos, então HStack é perfeito
                HStack(spacing: DSSpacing.medium.value) {
                    ForEach(types) { type in
                        DSPillView(
                            type.displayName,
                            backgroundToken: PokemonDetailsHelpers.typeColorToken(type),
                            foregroundToken: .brandPrimaryOn // ou .textPrimary dependendo do contraste
                        )
                    }
                }
            }
        }
    }

    // MARK: - Stats

    @ViewBuilder
    private func makeStatsSection() -> some View {
        if let model = viewModel.model {
            let rows: [DSStatsCardView.Row] = PokemonStatKind.allCases.map { kind in
                let value = model.statValue(kind) ?? .zero

                return .init(
                    id: kind.rawValue,
                    title: kind.displayName,
                    value: value,
                    progress: PokemonDetailsHelpers.normalizedStat(value),
                    barToken: PokemonDetailsHelpers.statBarToken(value)
                )
            }

            DSStatsCardView(
                title: "Base stats",
                rows: rows
            )
        }
    }
}
