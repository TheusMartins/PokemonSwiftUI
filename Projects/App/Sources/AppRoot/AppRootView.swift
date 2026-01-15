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

// MARK: - AppTab

enum AppTab: Hashable {
    case pokedex
    case team
    case search
}

// MARK: - AppRootView

struct AppRootView: View {

    // MARK: - State Objects

    @StateObject private var root = AppCompositionRoot()
    @StateObject private var deepLinkCoordinator = DeepLinkCoordinator()
    @StateObject private var searchContext = PokedexListingSearchContext()

    // MARK: - Body

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
                MainTabsView(
                    teamStore: teamStore,
                    searchContext: searchContext
                )
                .environmentObject(deepLinkCoordinator)
            }
        }
        .background(DSColorToken.background.color)
        .task {
            deepLinkCoordinator.bind(searchContext: searchContext)
        }
        .onOpenURL { url in
            guard let link = DeepLinkParser.parse(url) else { return }
            deepLinkCoordinator.handle(link)
        }
        .sheet(item: $deepLinkCoordinator.presentedPokemon) { item in
            NavigationStack {
                PokemonDetailsRouteView(pokemonName: item.name)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(String.closeTitle) { deepLinkCoordinator.dismissPresentedPokemon() }
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - MainTabsView

private struct MainTabsView: View {

    // MARK: - Environment

    @EnvironmentObject private var deepLinkCoordinator: DeepLinkCoordinator

    // MARK: - State

    @State private var pokedexSearchText: String = ""

    // MARK: - Dependencies

    let teamStore: TeamPokemonStore
    let searchContext: PokedexListingSearchContext

    // MARK: - Body

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                tabsIOS26
            } else {
                tabsLegacy
            }
        }
    }

    // MARK: - iOS 26+

    @available(iOS 26.0, *)
    private var tabsIOS26: some View {
        TabView(selection: $deepLinkCoordinator.selectedTab) {

            Tab(String.pokedexTitle, systemImage: .pokedexSystemImage, value: .pokedex) {
                PokedexListingRouteView(
                    searchText: $pokedexSearchText,
                    usesTabSearch: true,
                    searchContext: searchContext
                )
            }

            Tab(String.teamTitle, image: .teamAssetImage, value: .team) {
                PokemonTeamRouteView()
            }

            Tab(value: .search, role: .search) {
                PokedexListingRouteView(
                    searchText: $pokedexSearchText,
                    usesTabSearch: true,
                    searchContext: searchContext
                )
                .searchable(text: $pokedexSearchText)
            }
        }
    }

    // MARK: - iOS < 26

    private var tabsLegacy: some View {
        TabView(selection: $deepLinkCoordinator.selectedTab) {

            PokedexListingRouteView(
                searchText: $pokedexSearchText,
                usesTabSearch: false,
                searchContext: searchContext
            )
            .tabItem {
                Image(systemName: .pokedexSystemImage)
                Text(String.pokedexTitle)
            }
            .tag(AppTab.pokedex)

            PokemonTeamRouteView()
                .tabItem {
                    Image(.teamAssetImage)
                    Text(String.teamTitle)
                }
                .tag(AppTab.team)
        }
    }
}

// MARK: - Strings & Assets

private extension String {
    static let pokedexTitle = "Pokédex"
    static let teamTitle = "My Team"

    static let pokedexSystemImage = "magnifyingglass"
    static let teamAssetImage = "pokeballIcon"
}

private extension Button where Label == Text {
    static func close(action: @escaping () -> Void) -> some View {
        Button(String.closeTitle, action: action)
    }
}

private extension String {
    static let closeTitle = "Close"
}
