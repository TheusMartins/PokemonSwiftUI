//
//  PokemonListRepository.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import CoreNetworking
import Foundation

// MARK: - Repository protocol

protocol PokemonListRepository {
    func getGenerations() async throws -> PokemonGenerationModel
    func getPokemon(generationId: String) async throws -> PokemonListModel
}

final class PokemonListRepositoryImpl: PokemonListRepository {

    private let requester: Requester

    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }

    // MARK: - Public API

    func getGenerations() async throws -> PokemonGenerationModel {
        let response = try await requester.request(
            basedOn: PokemonListRequests.getGenerations
        )
        return try parseGenerationResponse(response.data)
    }

    func getPokemon(generationId: String) async throws -> PokemonListModel {
        let response = try await requester.request(
            basedOn: PokemonListRequests.getPokemons(generationId: generationId)
        )
        return try parsePokemonResponse(response.data)
    }

    // MARK: - Parsing

    private func parseGenerationResponse(_ data: Data) throws -> PokemonGenerationModel {
        try JSONDecoder().decode(PokemonGenerationModel.self, from: data)
    }

    private func parsePokemonResponse(_ data: Data) throws -> PokemonListModel {
        try JSONDecoder().decode(PokemonListModel.self, from: data)
    }
}
