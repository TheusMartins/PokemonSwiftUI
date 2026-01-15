//
//  PokemonDetailsRepository.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import CoreNetworking
import Foundation

protocol PokemonDetailsRepository {
    func getPokemonDetails(name: String) async throws -> PokemonDetailsModel
}

final class PokemonDetailsRepositoryImpl: PokemonDetailsRepository {

    private let requester: Requester

    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }

    // MARK: - Public API

    func getPokemonDetails(name: String) async throws -> PokemonDetailsModel {
        let response = try await requester.request(
            basedOn: PokemonDetailsRequest.getDetails(name: name)
        )

        return try parsePokemonDetailsResponse(response)
    }

    // MARK: - Parsing

    private func parsePokemonDetailsResponse(
        _ response: RequestSuccessResponse
    ) throws -> PokemonDetailsModel {
        try JSONDecoder().decode(PokemonDetailsModel.self, from: response.data)
    }
}
