//
//  PokemonListRequests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import CoreNetworking
import Foundation

enum PokemonListRequests {
    case getGenerations
    case getPokemons(generationId: String)
}

extension PokemonListRequests: RequestInfos {
    var endpoint: String {
        switch self {
        case .getGenerations:
            return .endpoint
        case .getPokemons(let generationId):
            return "\(String.endpoint)\(generationId)"
        }
    }
    
    var method: CoreNetworking.HTTPMethod {
        switch self {
        case .getGenerations:
            return .get
        case .getPokemons:
            return .get
        }
    }
}

private extension String {
    static var endpoint: String {
        "generation/"
    }
}
