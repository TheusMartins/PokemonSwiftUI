//
//  PokemonGenerationModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

struct PokemonGenerationModel: Codable {
    let results: [GenerationModel]
}

struct GenerationModel: Codable, Hashable, Sendable {
    let name: String
    let url: URL
}
