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

    // MARK: - Types

    enum State {
        case booting
        case ready(teamStore: TeamPokemonStore)
        case failed(message: String)
    }

    // MARK: - Published Properties

    @Published private(set) var state: State = .booting

    // MARK: - Open Methods

    func start() async {
        guard case .booting = state else { return }

        do {
            let store = try await TeamPokemonStoreImplementation.makeDefault()
            state = .ready(teamStore: store)
        } catch {
            state = .failed(message: .failedToInitializePersistence)
        }
    }
}

// MARK: - Strings

private extension String {
    static let failedToInitializePersistence = "Failed to initialize persistence."
}
