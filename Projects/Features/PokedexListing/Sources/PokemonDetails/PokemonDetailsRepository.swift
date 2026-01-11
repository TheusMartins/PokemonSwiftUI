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

    func getPokemonDetails(name: String) async throws -> PokemonDetailsModel {
        let response = try await requester.request(basedOn: PokemonDetailsRequest.getDetails(name: name))

        return try parsePokemonDetailsResponse(response: response)
    }

    // MARK: - Private methods

    private func parsePokemonDetailsResponse(
        response: RequestSuccessResponse
    ) throws -> PokemonDetailsModel {
        do {
            let model = try JSONDecoder().decode(PokemonDetailsModel.self,from: response.data)
            return model
        } catch {
            throw error
        }
    }
}
