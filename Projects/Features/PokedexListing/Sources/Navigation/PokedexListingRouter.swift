//
//  PokedexListingRouter.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation

@MainActor
final class PokedexListingRouter: ObservableObject {

    // MARK: - Properties

    @Published var path: [PokedexListingRoute] = []

    // MARK: - Navigation

    func push(_ route: PokedexListingRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    // MARK: - Deep Linking

    /// Deep link entry-point: opens the Pokédex already pushing the destination
    func openPokemonDetails(name: String) {
        path = [.pokemonDetails(name: name)]
    }
}
