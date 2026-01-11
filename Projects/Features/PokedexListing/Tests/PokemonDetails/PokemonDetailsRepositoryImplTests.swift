//
//  PokemonDetailsRepositoryImplTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
@testable import PokedexListing
import CoreNetworking

final class PokemonDetailsRepositoryImplTests: XCTestCase {

    // MARK: - Tests

    func test_getPokemonDetails_givenName_whenCalled_thenRequestsCorrectEndpoint() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonDetailsFixture.jsonData(name: "Scizor")
            )
        )

        // When
        _ = try await sut.getPokemonDetails(name: "Scizor".lowercased())

        // Then
        XCTAssertEqual(spy.requestCalls.count, 1)
        let infos = try XCTUnwrap(spy.requestCalls.first)

        XCTAssertEqual(infos.endpoint, "pokemon/scizor")
        XCTAssertEqual(infos.method, .get)
        XCTAssertEqual(infos.baseURL?.absoluteString, "https://pokeapi.co/api/v2/")
    }
    
    func test_getPokemonDetails_givenValidJSON_whenCalled_thenDecodesModel() async throws {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        spy.stubbedResult = .success(
            makeSuccessResponse(
                data: PokemonDetailsFixture.jsonData(id: 212, name: "Scizor")
            )
        )

        // When
        let model = try await sut.getPokemonDetails(name: "Scizor")

        // Then
        XCTAssertEqual(model.name.lowercased(), "scizor")
        XCTAssertEqual(model.id, 212)
        XCTAssertNotNil(model.sprites.frontDefault)
        XCTAssertNotNil(model.sprites.frontShiny)
        XCTAssertEqual(model.types.count, 2)
    }

    func test_getPokemonDetails_givenRequesterThrows_whenCalled_thenThrowsSameError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        let expectedError = DummyError.any
        spy.stubbedResult = .failure(expectedError)

        // When / Then
        do {
            _ = try await sut.getPokemonDetails(name: "Scizor")
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }

    func test_getPokemonDetails_givenInvalidJSON_whenCalled_thenThrowsDecodingError() async {
        // Given
        let spy = RequesterSpy()
        let sut = makeSUT(requester: spy)

        let invalidJSON = Data("not a json".utf8)
        spy.stubbedResult = .success(makeSuccessResponse(data: invalidJSON))

        // When / Then
        do {
            _ = try await sut.getPokemonDetails(name: "Scizor")
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            // Usually DecodingError, but could be something else depending on your model.
            // This keeps it resilient.
            XCTAssertTrue(error is DecodingError)
        }
    }

    // MARK: - SUT

    private func makeSUT(requester: RequesterSpy) -> PokemonDetailsRepositoryImpl {
        PokemonDetailsRepositoryImpl(requester: requester)
    }
}

/// Adjust ONLY here if RequestSuccessResponse initializer differs.
/// The repository only reads `response.data`, so we just need that field populated.
private func makeSuccessResponse(data: Data) -> RequestSuccessResponse {
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/scizor")!
    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    return RequestSuccessResponse(data: data, response: response)
}
