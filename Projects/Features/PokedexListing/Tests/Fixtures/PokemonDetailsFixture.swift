//
//  PokemonDetailsFixture.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation
@testable import PokedexListing

enum PokemonDetailsFixture {

    static func jsonData(
        id: Int = 212,
        name: String = "scizor"
    ) -> Data {
        let json = """
        {
          "id": \(id),
          "name": "\(name.lowercased())",
          "sprites": {
            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/212.png",
            "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/212.png"
          },
          "types": [
            { "slot": 1, "type": { "name": "bug" } },
            { "slot": 2, "type": { "name": "steel" } }
          ],
          "stats": [
            { "base_stat": 70, "stat": { "name": "hp" } },
            { "base_stat": 130, "stat": { "name": "attack" } },
            { "base_stat": 100, "stat": { "name": "defense" } },
            { "base_stat": 55, "stat": { "name": "special-attack" } },
            { "base_stat": 80, "stat": { "name": "special-defense" } },
            { "base_stat": 65, "stat": { "name": "speed" } }
          ]
        }
        """
        return Data(json.utf8)
    }

    static func model(
        id: Int = 212,
        name: String = "scizor"
    ) -> PokemonDetailsModel {
        let data = jsonData(id: id, name: name)
        do {
            return try JSONDecoder().decode(PokemonDetailsModel.self, from: data)
        } catch {
            fatalError("Invalid PokemonDetailsFixture JSON: \(error)")
        }
    }
}
