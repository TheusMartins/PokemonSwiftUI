//
//  DeepLinkParser.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation

enum DeepLinkParser {
    static func parse(_ url: URL) -> DeepLink? {
        guard url.scheme == "pokedex" else { return nil }

        let host = (url.host ?? "").lowercased()
        let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        switch host {

        case "pokemon":
            let nameFromPath = path
            let nameFromQuery = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "name" })?
                .value

            let name = (nameFromPath.isEmpty ? (nameFromQuery ?? "") : nameFromPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            return name.isEmpty ? nil : .pokemonDetails(name: name.lowercased())

        case "pokedex":
            let gen = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "generation" })?
                .value

            return .pokedex(generationId: gen)

        case "team":
            return .team

        default:
            return nil
        }
    }
}
