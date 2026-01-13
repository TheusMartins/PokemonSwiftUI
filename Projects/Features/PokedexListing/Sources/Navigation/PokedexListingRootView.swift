//
//  PokedexListingRootView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

import SwiftUI

public struct PokedexListingRouteView: View {
    @StateObject private var router = PokedexListingRouter()
    
    public init() {}

    public var body: some View {
        NavigationStack(path: $router.path) {
            PokemonListView(
                onPokemonSelected: { name in
                    router.push(.pokemonDetails(name: name))
                }
            )
            .navigationDestination(for: PokedexListingRoute.self) { route in
                switch route {
                case let .pokemonDetails(name):
                    PokemonDetailsRouteView(pokemonName: name)
                }
            }
        }
    }
}
