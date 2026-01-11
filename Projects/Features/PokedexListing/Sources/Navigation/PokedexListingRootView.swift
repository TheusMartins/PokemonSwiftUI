//
//  PokedexListingRootView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct PokedexListingRootView: View {
    @State private var path = NavigationPath()

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            PokemonListView(
                onPokemonSelected: { pokemonName in
                    path.append(PokedexListingRoute.details(pokemonName: pokemonName))
                }
            )
            .navigationDestination(for: PokedexListingRoute.self) { route in
                switch route {
                case .details(let name):
                    PokemonDetailsView(pokemonName: name)
                }
            }
        }
    }
}
