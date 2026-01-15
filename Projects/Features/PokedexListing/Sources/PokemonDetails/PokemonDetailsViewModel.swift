//
//  PokemonDetailsViewModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation
import SwiftUI
import CoreDesignSystem
import CorePersistence

@MainActor
final class PokemonDetailsViewModel: ObservableObject {

    // MARK: - Types

    struct FeedbackToast: Equatable, Identifiable {
        let id = UUID()
        let title: String
        let message: String?
        let style: DSFeedbackStyle
    }

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    private enum PendingAction {
        case add
        case remove
    }

    // MARK: - Dependencies

    private let repository: PokemonDetailsRepository
    private let pokemonName: String
    private let teamStore: TeamPokemonStore

    // MARK: - Published state

    @Published private(set) var model: PokemonDetailsModel?
    @Published var state: State = .idle

    @Published private(set) var isInTeam: Bool = false
    @Published private(set) var isTeamActionInProgress: Bool = false
    @Published var teamErrorMessage: String?

    @Published var feedbackToast: FeedbackToast?
    @Published var isConfirmPresented: Bool = false

    // MARK: - Private state

    private var pendingAction: PendingAction?

    // MARK: - Init

    init(
        pokemonName: String,
        repository: PokemonDetailsRepository = PokemonDetailsRepositoryImpl(),
        teamStore: TeamPokemonStore
    ) {
        self.pokemonName = pokemonName
        self.repository = repository
        self.teamStore = teamStore
    }

    // MARK: - Loading

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading

        do {
            let details = try await repository.getPokemonDetails(name: pokemonName.lowercased())
            model = details
            isInTeam = try await teamStore.contains(memberId: details.id)
            state = .loaded
        } catch {
            state = .failed(message: "Something went wrong")
        }
    }

    // MARK: - Team action (confirm + execute)

    func didTapTeamAction() {
        guard model != nil else { return }
        pendingAction = isInTeam ? .remove : .add
        isConfirmPresented = true
    }

    func confirmTeamAction() async {
        guard let model else { return }
        guard let action = pendingAction else { return }

        isConfirmPresented = false
        pendingAction = nil

        await runTeamAction(action, model: model)
    }

    // MARK: - Team refresh

    func refreshTeamStatus() async {
        guard let model else { return }
        do {
            isInTeam = try await teamStore.contains(memberId: model.id)
        } catch {
            // Silent failure: we don't want to break the details screen UX.
        }
    }

    // MARK: - Toast

    func dismissToast() {
        withAnimation(.snappy) {
            feedbackToast = nil
        }
    }

    // MARK: - Private helpers

    private func runTeamAction(_ action: PendingAction, model: PokemonDetailsModel) async {
        isTeamActionInProgress = true
        defer { isTeamActionInProgress = false }

        // Fake load to make the action feel deliberate.
        try? await Task.sleep(nanoseconds: 180_000_000)

        do {
            switch action {
            case .remove:
                try await teamStore.delete(memberId: model.id)
                isInTeam = false
                teamErrorMessage = nil
                showToast(
                    title: "Removed from team",
                    message: "\(model.name.capitalized) was removed.",
                    style: .success
                )

            case .add:
                try await teamStore.save(model.asTeamPokemon())
                isInTeam = true
                teamErrorMessage = nil
                showToast(
                    title: "Added to team",
                    message: "\(model.name.capitalized) was added.",
                    style: .success
                )
            }

        } catch let error as TeamPokemonStoreError {
            handleTeamStoreError(error, pokemonName: model.name)

        } catch {
            teamErrorMessage = "Something went wrong."
            showToast(
                title: "Action failed",
                message: teamErrorMessage,
                style: .error
            )
        }
    }

    private func handleTeamStoreError(_ error: TeamPokemonStoreError, pokemonName: String) {
        switch error {
        case .alreadyExists:
            isInTeam = true
            teamErrorMessage = "This Pokémon is already in your team."

        case .teamIsFull(let max):
            teamErrorMessage = "Your team is full (max \(max))."
        }

        showToast(
            title: "Action failed",
            message: teamErrorMessage,
            style: .error
        )
    }

    private func showToast(title: String, message: String?, style: DSFeedbackStyle) {
        withAnimation(.snappy) {
            feedbackToast = FeedbackToast(
                title: title,
                message: message,
                style: style
            )
        }
    }
}

// MARK: - Mapping

extension PokemonDetailsModel {
    func asTeamPokemon() -> TeamPokemon {
        TeamPokemon(
            id: id,
            name: name,
            spriteURL: sprites.frontDefault,
            types: types.compactMap { TeamPokemonType(rawValue: $0.rawValue) },
            stats: stats.compactMap { stat in
                guard let kind = TeamPokemonStatKind(rawValue: stat.kind.rawValue) else { return nil }
                return TeamPokemonStat(kind: kind, value: stat.value)
            }
        )
    }
}
