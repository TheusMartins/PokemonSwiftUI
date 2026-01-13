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

struct AppRootView: View {

    @StateObject private var root = AppCompositionRoot()

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
            }
        }
        .background(DSColorToken.background.color)
    }
}

private struct MainTabsView: View {

    let teamStore: TeamPokemonStore

    var body: some View {
        TabView {
            NavigationStack {
                PokedexListingRouteView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Pokédex")
            }

            NavigationStack {
                PokemonTeamRouteView()
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("My Team")
            }
        }
    }
}
