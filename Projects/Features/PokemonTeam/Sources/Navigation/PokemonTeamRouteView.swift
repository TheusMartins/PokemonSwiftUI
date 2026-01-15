//
//  PokemonTeamRouteView.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 12/01/26.
//

import SwiftUI

public struct PokemonTeamRouteView: View {

    // MARK: - Properties

    private let route: PokemonTeamRoute

    // MARK: - Init

    public init(route: PokemonTeamRoute = .team) {
        self.route = route
    }

    // MARK: - View

    public var body: some View {
        content
    }

    // MARK: - Routing

    @ViewBuilder
    private var content: some View {
        switch route {
        case .team:
            PokemonTeamViewContainer()
        }
    }
}
