//
//  AppCompositionRoot.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI
import CorePersistence

@MainActor
final class AppCompositionRoot: ObservableObject {

    enum State {
        case booting
        case ready(teamStore: TeamPokemonStore)
        case failed(message: String)
    }

    @Published private(set) var state: State = .booting

    func start() async {
        guard case .booting = state else { return }

        do {
            let store = try await TeamPokemonStoreImplementation.makeDefault()
            state = .ready(teamStore: store)
        } catch {
            state = .failed(message: "Failed to initialize persistence.")
        }
    }
}
