//
//  PokemonListFixtures.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation

enum PokemonListFixtures {

    static func generationsJSONData(count: Int = 2) -> Data {
        let json = """
        {
          "count": \(count),
          "next": null,
          "previous": null,
          "results": [
            { "name": "generation-i", "url": "https://pokeapi.co/api/v2/generation/1/" },
            { "name": "generation-ii", "url": "https://pokeapi.co/api/v2/generation/2/" }
          ]
        }
        """
        return Data(json.utf8)
    }

    static func pokemonListJSONData(
        generationId: Int = 1,
        generationName: String = "generation-i",
        pokemonNames: [String] = ["bulbasaur", "ivysaur"]
    ) -> Data {
        let speciesJSON = pokemonNames.enumerated().map { index, name in
            """
            { "name": "\(name)", "url": "https://pokeapi.co/api/v2/pokemon-species/\(index + 1)/" }
            """
        }.joined(separator: ",")

        // Esse payload segue o formato do endpoint /generation/{id}
        // (você pode ter no seu model só um subset disso; JSONDecoder ignora o que você não usa).
        let json = """
        {
          "id": \(generationId),
          "name": "\(generationName)",
          "pokemon_species": [\(speciesJSON)]
        }
        """
        return Data(json.utf8)
    }
}
