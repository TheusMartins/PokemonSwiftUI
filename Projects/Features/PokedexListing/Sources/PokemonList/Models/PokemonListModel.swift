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

struct PokemonModel: Codable, Identifiable {
    let name: String
    let url: URL

    // Stable id derived from the species URL (e.g. .../pokemon-species/1/)
    var id: Int { url.pokeId ?? 0 }

    // Sprite URL (Gen 1+ sprites)
    var imageURL: URL? {
        guard id > 0 else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}

private extension URL {
    var pokeId: Int? {
        // Handles trailing slash: .../1/
        let trimmed = absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let last = trimmed.split(separator: "/").last else { return nil }
        return Int(last)
    }
}
