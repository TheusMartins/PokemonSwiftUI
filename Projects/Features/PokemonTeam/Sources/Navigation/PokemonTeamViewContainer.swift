//
//  PokemonTeamViewContainer.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI
import CoreDesignSystem

struct PokemonTeamViewContainer: View {

    // MARK: - State

    @State private var viewModel: PokemonTeamViewModel?
    @State private var didFail: Bool = false

    // MARK: - View

    var body: some View {
        Group {
            if let viewModel {
                PokemonTeamView(viewModel: viewModel)
            } else if didFail {
                DSErrorScreenView {
                    Task { await load() }
                }
            } else {
                DSLoadingView(size: DSIconSize.huge.value)
            }
        }
        .task {
            await loadIfNeeded()
        }
    }

    // MARK: - Bootstrap

    private func loadIfNeeded() async {
        guard viewModel == nil, !didFail else { return }
        await load()
    }

    private func load() async {
        do {
            viewModel = try await PokemonTeamViewModel.makeDefault()
            didFail = false
        } catch {
            didFail = true
        }
    }
}
