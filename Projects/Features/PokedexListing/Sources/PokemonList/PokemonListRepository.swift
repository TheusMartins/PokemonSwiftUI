//
//  PokemonListRepository.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import CoreNetworking
import Foundation

protocol PokemonListRepository {
    func getGenerations() async throws -> PokemonGenerationModel
    func getPokemon(generationId: Int) async throws -> PokemonListModel
}

final class PokemonListRepositoryImpl: PokemonListRepository {
    private let requester: Requester
    
    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }
    
    func getGenerations() async throws -> PokemonGenerationModel {
        let response = try await requester.request(basedOn: PokemonListRequests.getGenerations)
        return try await parseGenerationResponse(response: response)
    }
    
    func getPokemon(generationId: Int) async throws -> PokemonListModel {
        let response = try await requester.request(basedOn: PokemonListRequests.getPokemons(generationId: generationId))
        return try await parsePokemonResponse(response: response)
    }
    
    // MARK: - Private methods
    
    private func parseGenerationResponse(response: RequestSuccessResponse) async throws -> PokemonGenerationModel {
        do {
            let model = try JSONDecoder().decode(PokemonGenerationModel.self, from: response.data)
            return model
        } catch {
            throw error
        }
    }
    
    private func parsePokemonResponse(response: RequestSuccessResponse) async throws -> PokemonListModel {
        do {
            let model = try JSONDecoder().decode(PokemonListModel.self, from: response.data)
            return model
        } catch {
            throw error
        }
    }
}
