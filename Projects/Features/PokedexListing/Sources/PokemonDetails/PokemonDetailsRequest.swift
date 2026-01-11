//
//  PokemonDetailsRequest.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import CoreNetworking
import Foundation

enum PokemonDetailsRequest {
    case getDetails(name: String)
}

extension PokemonDetailsRequest: RequestInfos {
    
    var endpoint: String {
        switch self {
        case .getDetails(let name):
            return "\(String.endpoint)\(name.lowercased())"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

private extension String {
    static let endpoint = "pokemon/"
}
