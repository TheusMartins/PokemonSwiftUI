//
//  DeepLinkParser.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation

enum DeepLinkParser {
    static func parse(_ url: URL) -> DeepLink? {
        // Ex: pokedex://pokemon/bulbasaur
        guard url.scheme == "pokedex" else { return nil }

        let host = url.host ?? ""
        let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        if host == "pokemon" {
            let name = path.isEmpty ? (URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "name" })?
                .value ?? "") : path

            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : .pokemonDetails(name: trimmed.lowercased())
        }

        if host == "pokedex" {
            let gen = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "generation" })?
                .value
            return .pokedex(generationId: gen)
        }

        return nil
    }
}
