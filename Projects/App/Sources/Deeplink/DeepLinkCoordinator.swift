//
//  DeepLinkCoordinator.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation
import SwiftUI

struct PresentedPokemon: Identifiable, Equatable {
    let name: String
    var id: String { name }
}

@MainActor
final class DeepLinkCoordinator: ObservableObject {

    @Published var selectedTab: AppTab = .pokedex
    @Published var presentedPokemon: PresentedPokemon? = nil

    func handle(_ deepLink: DeepLink) {
        switch deepLink {
        case let .pokemonDetails(name):
            presentedPokemon = PresentedPokemon(name: name)

        case .team:
            selectedTab = .team

        case .pokedex:
            selectedTab = .pokedex
        }
    }

    func dismissPresentedPokemon() {
        presentedPokemon = nil
    }
}
