//
//  PokemonListRepositoryImplTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
@testable import PokedexListing
import CoreNetworking

final class PokemonListRepositoryImplTests: XCTestCase {

    // MARK: - getGenerations

    func test_getGenerations_whenCalled_thenRequestsCorrectEndpoint() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonListFixtures.generationsJSONData()
            )
        )

        // When
        _ = try await sut.getGenerations()

        // Then
        XCTAssertEqual(spy.requestCalls.count, 1)

        let infos = try XCTUnwrap(spy.requestCalls.first)
        XCTAssertEqual(infos.endpoint, "generation/")
        XCTAssertEqual(infos.method, .get)
        XCTAssertEqual(infos.baseURL?.absoluteString, "https://pokeapi.co/api/v2/")
    }

    func test_getGenerations_givenValidJSON_whenCalled_thenDecodesModel() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonListFixtures.generationsJSONData(count: 3)
            )
        )

        // When
        let model = try await sut.getGenerations()

        // Then
        XCTAssertEqual(model.results.count, 2)
        XCTAssertFalse(model.results.isEmpty)
        XCTAssertEqual(model.results.first?.name.lowercased(), "generation-i")
    }

    func test_getGenerations_givenRequesterThrows_whenCalled_thenThrowsSameError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        let expectedError = DummyError.any
        spy.stubbedResult = .failure(expectedError)

        // When / Then
        do {
            _ = try await sut.getGenerations()
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }

    func test_getGenerations_givenInvalidJSON_whenCalled_thenThrowsDecodingError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: Data("not a json".utf8)
            )
        )

        // When / Then
        do {
            _ = try await sut.getGenerations()
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    // MARK: - getPokemon(generationId:)

    func test_getPokemon_givenGenerationId_whenCalled_thenRequestsCorrectEndpoint() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonListFixtures.pokemonListJSONData(generationId: 1)
            )
        )

        // When
        _ = try await sut.getPokemon(generationId: "1")

        // Then
        XCTAssertEqual(spy.requestCalls.count, 1)

        let infos = try XCTUnwrap(spy.requestCalls.first)
        XCTAssertEqual(infos.endpoint, "generation/1")
        XCTAssertEqual(infos.method, .get)
        XCTAssertEqual(infos.baseURL?.absoluteString, "https://pokeapi.co/api/v2/")
    }

    func test_getPokemon_givenValidJSON_whenCalled_thenDecodesModel() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonListFixtures.pokemonListJSONData(
                    generationId: 1,
                    pokemonNames: ["bulbasaur", "ivysaur", "venusaur"]
                )
            )
        )

        // When
        let model = try await sut.getPokemon(generationId: "1")

        // Then
        XCTAssertEqual(model.results.count, 3)
        XCTAssertFalse(model.results.isEmpty)
        XCTAssertEqual(model.results[0].name, "bulbasaur")
    }

    func test_getPokemon_givenRequesterThrows_whenCalled_thenThrowsSameError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        let expectedError = DummyError.any
        spy.stubbedResult = .failure(expectedError)

        // When / Then
        do {
            _ = try await sut.getPokemon(generationId: "1")
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }

    func test_getPokemon_givenInvalidJSON_whenCalled_thenThrowsDecodingError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: Data("not a json".utf8)
            )
        )

        // When / Then
        do {
            _ = try await sut.getPokemon(generationId: "1")
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    // MARK: - Helpers

    private func makeSUT(requester: RequesterSpy) -> PokemonListRepositoryImpl {
        PokemonListRepositoryImpl(requester: requester)
    }

    private func makeSuccessResponse(data: Data) -> RequestSuccessResponse {
        let url = URL(string: "https://pokeapi.co/api/v2/generation/")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return RequestSuccessResponse(data: data, response: response)
    }
}
