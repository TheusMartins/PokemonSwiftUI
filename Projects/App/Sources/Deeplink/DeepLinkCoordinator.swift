//
//  DeepLinkCoordinator.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation
import SwiftUI
import PokedexListing

// MARK: - PresentedPokemon

struct PresentedPokemon: Identifiable, Equatable {

    // MARK: - Properties

    let name: String
    var id: String { name }
}

// MARK: - DeepLinkCoordinator

@MainActor
final class DeepLinkCoordinator: ObservableObject {

    // MARK: - Published Properties

    @Published var selectedTab: AppTab = .pokedex
    @Published var presentedPokemon: PresentedPokemon? = nil

    // MARK: - Private Properties

    private weak var searchContext: PokedexListingSearchContext?

    // MARK: - Binding

    func bind(searchContext: PokedexListingSearchContext) {
        self.searchContext = searchContext
    }

    // MARK: - Open Methods

    func handle(_ deepLink: DeepLink) {
        switch deepLink {

        case let .pokemonDetails(name):
            presentedPokemon = PresentedPokemon(name: name)

        case .team:
            presentedPokemon = nil
            selectedTab = .team

        case let .pokedex(generationId):
            presentedPokemon = nil
            selectedTab = .pokedex
            writeGenerationToContextIfNeeded(generationId)
        }
    }

    func dismissPresentedPokemon() {
        presentedPokemon = nil
    }

    // MARK: - Private Methods

    private func writeGenerationToContextIfNeeded(_ generationId: String?) {
        let trimmed = generationId?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmed, !trimmed.isEmpty else { return }
        searchContext?.selectedGenerationId = normalizeGenerationId(trimmed)
    }

    private func normalizeGenerationId(_ raw: String) -> String {
        let lower = raw.lowercased()

        // If user sends "generation-i" already, keep it
        if lower.hasPrefix(.generationPrefix) { return lower }

        // Accept "1", "2", "3"...
        if let n = Int(lower), (1...9).contains(n) {
            return "generation-\(romanForOneToNine[n] ?? "i")"
        }

        // Fallback: keep whatever came (but lowercased)
        return lower
    }

    private var romanForOneToNine: [Int: String] {
        [
            1: "i", 2: "ii", 3: "iii", 4: "iv", 5: "v",
            6: "vi", 7: "vii", 8: "viii", 9: "ix"
        ]
    }
}

// MARK: - Magic Strings

private extension String {
    static let generationPrefix = "generation-"
}
