//
//  PokemonTeamRouteView.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 12/01/26.
//


import SwiftUI

public struct PokemonTeamRouteView: View {

    private let route: PokemonTeamRoute

    public init(route: PokemonTeamRoute = .team) {
        self.route = route
    }

    public var body: some View {
        switch route {
        case .team:
            PokemonTeamView(viewModel: .init(store: PreviewPokemonTeamStore()))
        }
    }
}
