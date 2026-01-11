//
//  PokedexListingRouter.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation

@MainActor
final class PokedexListingRouter: ObservableObject {
    @Published var path: [PokedexListingRoute] = []

    func push(_ route: PokedexListingRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    /// Deep link entry-point: abre a pokedex já “empurrando” o destino
    func openPokemonDetails(name: String) {
        path = [.pokemonDetails(name: name)]
    }
}
