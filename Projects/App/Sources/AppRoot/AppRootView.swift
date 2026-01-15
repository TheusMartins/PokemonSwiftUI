//
//  AppRootView.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI
import CoreDesignSystem
import PokedexListing
import PokemonTeam
import CorePersistence

enum AppTab: Hashable {
    case pokedex
    case team
}

struct AppRootView: View {
    @StateObject private var root = AppCompositionRoot()
    @StateObject private var deepLinkCoordinator = DeepLinkCoordinator()

    var body: some View {
        Group {
            switch root.state {
            case .booting:
                DSLoadingView(size: DSIconSize.huge.value)
                    .task { await root.start() }

            case .failed(let message):
                DSErrorScreenView(title: message) {
                    Task { await root.start() }
                }

            case .ready(let teamStore):
                MainTabsView(teamStore: teamStore)
                    .environmentObject(deepLinkCoordinator)
            }
        }
        .background(DSColorToken.background.color)
        .onOpenURL { url in
            guard let link = DeepLinkParser.parse(url) else { return }
            deepLinkCoordinator.handle(link)
        }
        .sheet(item: $deepLinkCoordinator.presentedPokemon) { item in
            NavigationStack {
                PokemonDetailsRouteView(pokemonName: item.name)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") {
                                deepLinkCoordinator.dismissPresentedPokemon() 
                            }
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

private struct MainTabsView: View {
    @StateObject private var searchContext = PokedexListingSearchContext()

    @EnvironmentObject private var deepLinkCoordinator: DeepLinkCoordinator
    @State private var pokedexSearchText: String = ""

    let teamStore: TeamPokemonStore

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                tabsIOS26
            } else {
                tabsLegacy
            }
        }
    }

    @available(iOS 26.0, *)
    private var tabsIOS26: some View {
        TabView {

            Tab("Pokédex", systemImage: "magnifyingglass") {
                PokedexListingRouteView(
                    searchText: $pokedexSearchText,
                    usesTabSearch: true,
                    searchContext: searchContext
                )
            }

            Tab("My Team", image: "pokeballIcon") {
                PokemonTeamRouteView()
            }

            Tab(role: .search) {
                PokedexListingRouteView(
                    searchText: $pokedexSearchText,
                    usesTabSearch: true,
                    searchContext: searchContext
                )
                .searchable(text: $pokedexSearchText)
            }
        }
    }

    private var tabsLegacy: some View {
        TabView(selection: $deepLinkCoordinator.selectedTab) {
            PokedexListingRouteView(
                searchText: $pokedexSearchText,
                usesTabSearch: false,
                searchContext: searchContext
            )
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Pokédex")
            }
            .tag(AppTab.pokedex)

            PokemonTeamRouteView()
                .tabItem {
                    Image("pokeballIcon")
                    Text("My Team")
                }
                .tag(AppTab.team)
        }
    }
}
