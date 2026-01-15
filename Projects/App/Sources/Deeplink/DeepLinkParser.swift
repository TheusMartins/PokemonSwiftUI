//
//  DeepLinkParser.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation

enum DeepLinkParser {

    // MARK: - Public API

    static func parse(_ url: URL) -> DeepLink? {
        guard isValidScheme(url) else { return nil }

        let host = normalizedHost(from: url)
        let path = normalizedPath(from: url)

        switch host {
        case .pokemonHost:
            return parsePokemon(path: path, url: url)

        case .pokedexHost:
            return parsePokedex(url: url)

        case .teamHost:
            return .team

        default:
            return nil
        }
    }
}

// MARK: - Parsing Helpers

private extension DeepLinkParser {

    static func parsePokemon(path: String, url: URL) -> DeepLink? {
        let nameFromPath = path
        let nameFromQuery = queryValue(
            from: url,
            key: .pokemonNameQueryKey
        )

        let name = (nameFromPath.isEmpty ? (nameFromQuery ?? "") : nameFromPath)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else { return nil }
        return .pokemonDetails(name: name.lowercased())
    }

    static func parsePokedex(url: URL) -> DeepLink {
        let generationId = queryValue(
            from: url,
            key: .generationQueryKey
        )
        return .pokedex(generationId: generationId)
    }
}

// MARK: - URL Helpers

private extension DeepLinkParser {

    static func isValidScheme(_ url: URL) -> Bool {
        url.scheme == .pokedexScheme
    }

    static func normalizedHost(from url: URL) -> String {
        (url.host ?? "").lowercased()
    }

    static func normalizedPath(from url: URL) -> String {
        url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    static func queryValue(from url: URL, key: String) -> String? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }
}

private extension String {

    // MARK: Scheme
    static let pokedexScheme = "pokedex"

    // MARK: Hosts
    static let pokemonHost = "pokemon"
    static let pokedexHost = "pokedex"
    static let teamHost = "team"

    // MARK: Query Keys
    static let pokemonNameQueryKey = "name"
    static let generationQueryKey = "generation"
}
