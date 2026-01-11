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
                EmptyView()

            case .loading:
                DSLoadingView(size: 60)

            case .loaded:
                makeContent()

            case .failed:
                makeErrorView()
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
            makeSpriteCard(title: "Default", url: frontDefault)
            makeSpriteCard(title: "Shiny", url: frontShiny)
        }
    }

    private func makeSpriteCard(title: String, url: URL?) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.medium.value) {
            DSText(title, style: .body, color: .textSecondary)

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DSColorToken.surface.color)

                Group {
                    if let url {
                        RemoteImageView(
                            url: url,
                            placeholder: { Color.clear },
                            loading: { DSLoadingView(size: 22) },
                            failure: { Image(systemName: "photo").imageScale(.large) }
                        )
                        .padding(DSSpacing.large.value)
                    } else {
                        DSText("No image", style: .body, color: .textSecondary)
                    }
                }
            }
            .frame(height: 160)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                            backgroundToken: type.colorToken,
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
                let value = model.statValue(kind) ?? 0

                return .init(
                    id: kind.rawValue,
                    title: kind.displayName,
                    value: value,
                    progress: normalizedStat(value),
                    barToken: statBarToken(value)
                )
            }

            DSStatsCardView(
                title: "Base stats",
                rows: rows
            )
        }
    }

    // MARK: - Error

    private func makeErrorView() -> some View {
        VStack(spacing: DSSpacing.large.value) {
            DSText("Something went wrong", style: .title)

            Button("Retry") {
                Task { await viewModel.load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func normalizedStat(_ value: Int) -> CGFloat {
        let maxValue: CGFloat = 200
        return min(max(CGFloat(value) / maxValue, 0), 1)
    }

    private func statBarToken(_ value: Int) -> DSColorToken {
        switch value {
        case ..<60:
            return .danger
        case 60..<100:
            return .pokemonYellow
        case 100..<145:
            return .pokemonGreen
        default:
            return .pokemonTeal
        }
    }
}
