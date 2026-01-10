//
//  PokemonListModel.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

struct PokemonListModel: Codable {
    let results: [PokemonModel]
    
    enum CodingKeys: String, CodingKey {
        case results = "pokemon_species"
    }
}

struct PokemonModel: Codable {
    let name: String
    let url: URL
}
