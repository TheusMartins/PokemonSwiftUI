//
//  DeepLinkCoordinator.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation
import SwiftUI
import PokedexListing

struct PresentedPokemon: Identifiable, Equatable {
    let name: String
    var id: String { name }
}

@MainActor
final class DeepLinkCoordinator: ObservableObject {

    @Published var selectedTab: AppTab = .pokedex
    @Published var presentedPokemon: PresentedPokemon? = nil

    private weak var searchContext: PokedexListingSearchContext?

    func bind(searchContext: PokedexListingSearchContext) {
        self.searchContext = searchContext
    }

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

            let trimmed = generationId?.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let trimmed, !trimmed.isEmpty else { return }

            // normalize: accept "1" or "generation-i" etc
            searchContext?.selectedGenerationId = normalizeGenerationId(trimmed)
        }
    }

    func dismissPresentedPokemon() {
        presentedPokemon = nil
    }

    private func normalizeGenerationId(_ raw: String) -> String {
        let lower = raw.lowercased()

        // If user sends "generation-i" already, keep it
        if lower.hasPrefix("generation-") { return lower }

        // Accept "1", "2", "3"...
        if let n = Int(lower), (1...9).contains(n) {
            let roman: [Int: String] = [
                1: "i", 2: "ii", 3: "iii", 4: "iv", 5: "v",
                6: "vi", 7: "vii", 8: "viii", 9: "ix"
            ]
            return "generation-\(roman[n] ?? "i")"
        }

        // fallback: keep whatever came (but lowercased)
        return lower
    }
}
