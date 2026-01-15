//
//  DeepLink.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

enum DeepLink: Equatable {
    case pokemonDetails(name: String)
    case pokedex(generationId: String?)
    case team
}
