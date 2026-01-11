//
//  PokemonListViewModelTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
@testable import PokedexListing

@MainActor
final class PokemonListViewModelTests: XCTestCase {

    // MARK: - Tests

    func test_init_setsInitialStateToIdle_andCollectionsAreEmpty() {
        // Given
        let sut = makeSUT()

        // Then
        assertState(sut.state, is: .idle)
        XCTAssertTrue(sut.generations.isEmpty)
        XCTAssertTrue(sut.pokemons.isEmpty)
        XCTAssertNil(sut.selectedGeneration)
    }

    func test_loadIfNeeded_givenStateIsIdle_whenCalled_thenLoads() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedGenerationsResult = .success(makeGenerations([.init(name: "generation-i", url: URL(string: "https://google.com")!)]))
        spy.stubbedPokemonResult = .success(makePokemons([.init(name: "bulbasaur", url: URL(string: "https://google.com")!)]))

        let sut = makeSUT(repository: spy)

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 1)
        XCTAssertEqual(spy.getPokemonCalls, ["generation-i"])

        assertState(sut.state, is: .loaded)
        XCTAssertEqual(sut.generations.map(\.name), ["generation-i"])
        XCTAssertEqual(sut.selectedGeneration?.name, "generation-i")
        XCTAssertEqual(sut.pokemons.map(\.name), ["bulbasaur"])
    }

    func test_loadIfNeeded_givenStateIsLoading_whenCalled_thenDoesNotLoad() async {
        // Given
        let spy = PokemonListRepositorySpy()
        let sut = makeSUT(repository: spy)
        sut.state = .loading

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 0)
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)
        assertState(sut.state, is: .loading)
    }

    func test_loadIfNeeded_givenStateIsLoaded_whenCalled_thenDoesNotLoad() async {
        // Given
        let spy = PokemonListRepositorySpy()
        let sut = makeSUT(repository: spy)
        sut.state = .loaded

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 0)
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)
        assertState(sut.state, is: .loaded)
    }

    func test_loadIfNeeded_givenStateIsFailed_whenCalled_thenDoesNotLoad() async {
        // Given
        let spy = PokemonListRepositorySpy()
        let sut = makeSUT(repository: spy)
        sut.state = .failed(message: "Anything")

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 0)
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)
        assertState(sut.state, is: .failed(message: "Anything"))
    }

    func test_load_givenRepositorySuccess_setsGenerationsSelectsFirst_loadsPokemons_andSetsLoaded() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedGenerationsResult = .success(makeGenerations([
            .init(name: "generation-i", url: URL(string: "https://google.com")!),
            .init(name: "generation-ii", url: URL(string: "https://google.com")!)
        ]))
        spy.stubbedPokemonResult = .success(makePokemons([
            .init(name: "bulbasaur", url: URL(string: "https://google.com")!),
            .init(name: "ivysaur", url: URL(string: "https://google.com")!)
        ]))

        let sut = makeSUT(repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 1)
        XCTAssertEqual(spy.getPokemonCalls, ["generation-i"])

        assertState(sut.state, is: .loaded)
        XCTAssertEqual(sut.generations.map(\.name), ["generation-i", "generation-ii"])
        XCTAssertEqual(sut.selectedGeneration?.name, "generation-i")
        XCTAssertEqual(sut.pokemons.map(\.name), ["bulbasaur", "ivysaur"])
    }

    func test_load_givenGetGenerationsThrows_setsFailed_andDoesNotRequestPokemon() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedGenerationsResult = .failure(anyError())
        let sut = makeSUT(repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 1)
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)

        assertState(sut.state, is: .failed(message: "Something went wrong"))
        XCTAssertTrue(sut.generations.isEmpty)
        XCTAssertTrue(sut.pokemons.isEmpty)
        XCTAssertNil(sut.selectedGeneration)
    }

    func test_load_givenGetPokemonThrows_setsFailed_butKeepsGenerationsAndSelected() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedGenerationsResult = .success(makeGenerations([
            .init(name: "generation-i", url: URL(string: "https://google.com")!)
        ]))
        spy.stubbedPokemonResult = .failure(anyError())
        let sut = makeSUT(repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 1)
        XCTAssertEqual(spy.getPokemonCalls, ["generation-i"])

        assertState(sut.state, is: .failed(message: "Something went wrong"))
        XCTAssertEqual(sut.generations.map(\.name), ["generation-i"])
        XCTAssertEqual(sut.selectedGeneration?.name, "generation-i")
        XCTAssertTrue(sut.pokemons.isEmpty)
    }

    func test_load_givenGenerationsEmpty_setsLoaded_andDoesNotRequestPokemon() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedGenerationsResult = .success(makeGenerations([]))
        let sut = makeSUT(repository: spy)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(spy.getGenerationsCallsCount, 1)
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)

        assertState(sut.state, is: .loaded)
        XCTAssertTrue(sut.generations.isEmpty)
        XCTAssertNil(sut.selectedGeneration)
        XCTAssertTrue(sut.pokemons.isEmpty)
    }

    func test_changeGeneration_givenValidGeneration_whenRepositorySuccess_setsSelectedLoadsPokemons_andSetsLoaded() async {
        // Given
        let spy = PokemonListRepositorySpy()
        spy.stubbedPokemonResult = .success(makePokemons([
            .init(name: "charmander", url: URL(string: "https://google.com")!)
        ]))

        let sut = makeSUT(repository: spy)

        // When
        await sut.changeGeneration(to: .init(name: "generation-i", url: URL(string: "https://google.com")!))

        // Then
        XCTAssertEqual(sut.selectedGeneration?.name, "generation-i")
        XCTAssertEqual(spy.getPokemonCalls, ["generation-i"])

        assertState(sut.state, is: .loaded)
        XCTAssertEqual(sut.pokemons.map(\.name), ["charmander"])
    }

    func test_changeGeneration_givenValidGeneration_whenRepositoryThrows_setsFailed_andDoesNotChangePokemons() async {
        // Given
        let spy = PokemonListRepositorySpy()

        // 1) First load succeeds and seeds pokemons
        spy.stubbedGenerationsResult = .success(makeGenerations([
            .init(name: "generation-i", url: URL(string: "https://google.com")!)
        ]))
        spy.stubbedPokemonResult = .success(makePokemons([
            .init(name: "existing", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/1/")!)
        ]))

        let sut = makeSUT(repository: spy)
        await sut.load()

        XCTAssertEqual(sut.pokemons.map(\.name), ["existing"])

        // 2) Now changeGeneration fails
        spy.stubbedPokemonResult = .failure(anyError())

        // When
        await sut.changeGeneration(to: .init(name: "generation-ii", url: URL(string: "https://google.com")!))

        // Then
        XCTAssertEqual(sut.selectedGeneration?.name, "generation-ii")
        XCTAssertEqual(spy.getPokemonCalls, ["generation-i", "generation-ii"])

        assertState(sut.state, is: .failed(message: "Something went wrong"))
        XCTAssertEqual(sut.pokemons.map(\.name), ["existing"]) // still the same ✅
    }

    func test_changeGeneration_givenEmptyName_setsFailedInvalidGenerationId_andDoesNotRequestRepository() async {
        // Given
        let spy = PokemonListRepositorySpy()
        let sut = makeSUT(repository: spy)

        // When
        await sut.changeGeneration(to: .init(name: "", url: URL(string: "https://google.com")!))

        // Then
        XCTAssertEqual(sut.selectedGeneration?.name, "")
        XCTAssertTrue(spy.getPokemonCalls.isEmpty)

        assertState(sut.state, is: .failed(message: "Invalid generation id"))
    }

    // MARK: - Helpers

    private func makeSUT(
        repository: PokemonListRepository = PokemonListRepositorySpy()
    ) -> PokemonListViewModel {
        PokemonListViewModel(repository: repository)
    }

    private func anyError() -> NSError {
        NSError(domain: "PokemonListViewModelTests", code: 0)
    }

    private func makeGenerations(_ generations: [GenerationModel]) -> PokemonGenerationModel {
        PokemonGenerationModel(results: generations)
    }

    private func makePokemons(_ pokemons: [PokemonModel]) -> PokemonListModel {
        PokemonListModel(results: pokemons)
    }

    private enum ExpectedState: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
    }

    private func assertState(_ actual: PokemonListViewModel.State, is expected: ExpectedState, file: StaticString = #filePath, line: UInt = #line) {
        switch (actual, expected) {
        case (.idle, .idle),
             (.loading, .loading),
             (.loaded, .loaded):
            return

        case let (.failed(message: a), .failed(message: e)):
            XCTAssertEqual(a, e, file: file, line: line)

        default:
            XCTFail("Expected state \(expected), got \(actual)", file: file, line: line)
        }
    }
}

// MARK: - Spy

private final class PokemonListRepositorySpy: PokemonListRepository {

    private(set) var getGenerationsCallsCount: Int = 0
    private(set) var getPokemonCalls: [String] = []

    var stubbedGenerationsResult: Result<PokemonGenerationModel, Error> = .failure(NSError(domain: "Unstubbed", code: 0))
    var stubbedPokemonResult: Result<PokemonListModel, Error> = .failure(NSError(domain: "Unstubbed", code: 0))

    func getGenerations() async throws -> PokemonGenerationModel {
        getGenerationsCallsCount += 1
        return try stubbedGenerationsResult.get()
    }

    func getPokemon(generationId: String) async throws -> PokemonListModel {
        getPokemonCalls.append(generationId)
        return try stubbedPokemonResult.get()
    }
}
