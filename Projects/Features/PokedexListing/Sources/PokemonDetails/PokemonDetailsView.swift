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

    init(viewModel: PokemonDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            contentRoot
                .background(DSColorToken.background.color)
                .navigationTitle(viewModel.model?.name.capitalized ?? "Details")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await viewModel.loadIfNeeded()
                    await viewModel.refreshTeamStatus()
                }
                .alert("Team", isPresented: $viewModel.isConfirmPresented) {
                    Button(viewModel.isInTeam ? "Remove" : "Add", role: viewModel.isInTeam ? .destructive : nil) {
                        Task { await viewModel.confirmTeamAction() }
                    }

                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text(confirmMessage)
                }

            toastOverlay
        }
    }

    // MARK: - Root Content

    @ViewBuilder
    private var contentRoot: some View {
        switch viewModel.state {
        case .idle, .loading:
            DSLoadingView(size: DSIconSize.huge.value)

        case .loaded:
            makeContent()

        case .failed(let errorMessage):
            DSErrorScreenView(title: errorMessage) {
                Task { await viewModel.loadIfNeeded() }
            }
        }
    }

    // MARK: - Content

    private func makeContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xLarge.value) {
                makeSpritesRow()
                makeTypesSection()
                makeStatsSection()
                teamActionButton()
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

                HStack(spacing: DSSpacing.medium.value) {
                    ForEach(types) { type in
                        DSPillView(
                            type.displayName,
                            backgroundToken: PokemonDetailsHelpers.typeColorToken(type),
                            foregroundToken: .brandPrimaryOn
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

    // MARK: - Team Action

    @ViewBuilder
    private func teamActionButton() -> some View {
        DSButton(
            title: viewModel.isInTeam ? "Remove from Team" : "Add to Team",
            style: viewModel.isInTeam ? .secondary : .primary,
            isLoading: viewModel.isTeamActionInProgress
        ) {
            Task { @MainActor in
                viewModel.didTapTeamAction()
            }
        }
        .disabled(viewModel.model == nil || viewModel.isTeamActionInProgress)
    }

    private var confirmMessage: String {
        guard let name = viewModel.model?.name.capitalized else { return "" }
        return viewModel.isInTeam
            ? "Remove \(name) from your team?"
            : "Add \(name) to your team?"
    }

    // MARK: - Toast

    @ViewBuilder
    private var toastOverlay: some View {
        if let toast = viewModel.feedbackToast {
            DSFeedbackToast(
                title: toast.title,
                message: toast.message,
                style: toast.style,
                onDismiss: {
                    Task { @MainActor in
                        viewModel.dismissToast()
                    }
                }
            )
            .padding(.horizontal, DSSpacing.xLarge.value)
            .padding(.top, DSSpacing.large.value)
            .zIndex(1)
        }
    }
}
