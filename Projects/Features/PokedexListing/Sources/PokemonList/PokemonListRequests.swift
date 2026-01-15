//
//  PokemonListRequests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation
import CoreNetworking

// MARK: - Requests

enum PokemonListRequests {
    case getGenerations
    case getPokemons(generationId: String)
}

// MARK: - RequestInfos

extension PokemonListRequests: RequestInfos {

    var endpoint: String {
        switch self {
        case .getGenerations:
            return .generationEndpoint

        case .getPokemons(let generationId):
            return "\(String.generationEndpoint)\(generationId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getGenerations, .getPokemons:
            return .get
        }
    }
}

// MARK: - Constants

private extension String {
    static let generationEndpoint = "generation/"
}
