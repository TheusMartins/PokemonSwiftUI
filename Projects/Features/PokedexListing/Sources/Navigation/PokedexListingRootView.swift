//
//  PokedexListingRootView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct PokedexListingRouteView: View {

    // MARK: - State

    @StateObject private var router = PokedexListingRouter()
    @StateObject private var viewModel: PokemonListViewModel
    @ObservedObject private var searchContext: PokedexListingSearchContext

    // MARK: - Inputs

    @Binding private var searchText: String
    private let usesTabSearch: Bool

    // MARK: - Init

    public init(
        searchText: Binding<String>,
        usesTabSearch: Bool,
        searchContext: PokedexListingSearchContext
    ) {
        _searchText = searchText
        self.usesTabSearch = usesTabSearch
        _searchContext = ObservedObject(wrappedValue: searchContext)
        _viewModel = StateObject(wrappedValue: PokemonListViewModel(searchContext: searchContext))
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack(
            path: Binding(
                get: { router.path },
                set: { router.path = $0 }
            )
        ) {
            PokemonListView(
                viewModel: viewModel,
                onPokemonSelected: { name in
                    router.push(.pokemonDetails(name: name))
                },
                searchText: $searchText,
                usesTabSearch: usesTabSearch
            )
            .navigationDestination(for: PokedexListingRoute.self) { route in
                switch route {
                case let .pokemonDetails(name):
                    PokemonDetailsRouteView(pokemonName: name)
                }
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .task(id: searchContext.selectedGenerationId) {
            await viewModel.applyGenerationFromContextIfNeeded()
        }
    }
}
