//
//  PokemonDetailsViewModelTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
@testable import PokedexListing

@MainActor
final class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Tests

    func test_init_setsInitialStateToIdle_andModelIsNil() {
        // Given
        let sut = makeSUT(pokemonName: "Scizor")

        // Then
        XCTAssertEqual(sut.state, .idle)
        XCTAssertNil(sut.model)
    }

    func test_loadIfNeeded_givenStateIsIdle_whenCalled_thenLoadsAndRequestsLowercasedName() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        spy.stubbedResult = .success(
            PokemonDetailsFixture.model(name: "scizor")
        )
        let sut = makeSUT(pokemonName: "ScIzOr", repository: spy)

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.calls.count, 1)
        XCTAssertEqual(spy.calls.first?.name, "scizor")
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.model?.name.lowercased(), "scizor")
    }

    func test_loadIfNeeded_givenStateIsLoading_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)
        sut.state = .loading

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.calls.count, 0)
        XCTAssertEqual(sut.state, .loading)
    }

    func test_loadIfNeeded_givenStateIsLoaded_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)
        sut.state = .loaded

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.calls.count, 0)
        XCTAssertEqual(sut.state, .loaded)
    }

    func test_loadIfNeeded_givenStateIsFailed_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)
        sut.state = .failed(message: "Anything")

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.calls.count, 0)
        XCTAssertEqual(sut.state, .failed(message: "Anything"))
    }

    func test_load_givenRepositorySuccess_setsLoadingThenLoaded_andSetsModel() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        spy.stubbedResult = .success(
            PokemonDetailsFixture.model(name: "scizor")
        )
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.calls.count, 1)
        XCTAssertEqual(spy.calls.first?.name, "scizor")
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.model?.name.lowercased(), "scizor")
    }

    func test_load_givenRepositoryFailure_setsLoadingThenFailed_andDoesNotSetModel() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        spy.stubbedResult = .failure(anyError())
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.calls.count, 1)
        XCTAssertEqual(sut.state, .failed(message: "Something went wrong"))
        XCTAssertNil(sut.model)
    }

    func test_load_whenCalledMultipleTimes_requestsRepositoryEveryTime() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        spy.stubbedResult = .success(
            PokemonDetailsFixture.model(name: "scizor")
        )
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)

        // When
        await sut.load()
        await sut.load()

        // Then
        XCTAssertEqual(spy.calls.count, 2)
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertNotNil(sut.model)
    }

    func test_load_givenPreviouslyFailed_whenCalledAgain_andNowSucceeds_recoversToLoaded() async {
        // Given
        let spy = PokemonDetailsRepositorySpy()
        spy.stubbedResult = .failure(anyError())
        let sut = makeSUT(pokemonName: "Scizor", repository: spy)

        // When 1 (fails)
        await sut.load()

        // Then 1
        XCTAssertEqual(sut.state, .failed(message: "Something went wrong"))
        XCTAssertNil(sut.model)

        // Given 2 (now succeeds)
        spy.stubbedResult = .success(
            PokemonDetailsFixture.model(name: "scizor")
        )

        // When 2
        await sut.load()

        // Then 2
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.model?.name.lowercased(), "scizor")
        XCTAssertEqual(spy.calls.count, 2)
    }

    // MARK: - Helpers

    private func makeSUT(
        pokemonName: String,
        repository: PokemonDetailsRepository = PokemonDetailsRepositorySpy()
    ) -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(
            pokemonName: pokemonName,
            repository: repository
        )
    }

    private func anyError() -> NSError {
        NSError(domain: "PokemonDetailsViewModelTests", code: 0)
    }
}

// MARK: - Spy

private final class PokemonDetailsRepositorySpy: PokemonDetailsRepository {

    struct Call: Equatable {
        let name: String
    }

    var calls: [Call] = []
    var stubbedResult: Result<PokemonDetailsModel, Error> = .failure(NSError(domain: "Unstubbed", code: 0))

    func getPokemonDetails(name: String) async throws -> PokemonDetailsModel {
        calls.append(.init(name: name))
        return try stubbedResult.get()
    }
}
