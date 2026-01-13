//
//  PokemonDetailsViewModelTests.swift
//  PokedexListingTests
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
import CorePersistence
@testable import PokedexListing

@MainActor
final class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Tests (Init)

    func test_init_setsInitialStateToIdle_andModelIsNil() async {
        // Given
        let sut = makeSUT(pokemonName: "Scizor")

        // Then
        XCTAssertEqual(sut.state, .idle)
        XCTAssertNil(sut.model)
        XCTAssertEqual(sut.isInTeam, false)
        XCTAssertEqual(sut.isTeamActionInProgress, false)
        XCTAssertNil(sut.teamErrorMessage)
        XCTAssertNil(sut.feedbackToast)
        XCTAssertEqual(sut.isConfirmPresented, false)
    }

    // MARK: - Tests (LoadIfNeeded)

    func test_loadIfNeeded_givenStateIsIdle_whenCalled_thenLoads_requestsLowercasedName_andChecksContains() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()
        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(true)

        let sut = makeSUT(
            pokemonName: "ScIzOr",
            repository: repo,
            teamStore: teamStore
        )

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(repo.calls.count, 1)
        XCTAssertEqual(repo.calls.first?.name, "scizor")
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.model?.name.lowercased(), "scizor")

        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls, [model.id])
        XCTAssertEqual(sut.isInTeam, true)
    }

    func test_loadIfNeeded_givenStateIsLoading_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        sut.state = .loading

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(repo.calls.count, 0)
        XCTAssertEqual(sut.state, .loading)
        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls.count, 0)
    }

    func test_loadIfNeeded_givenStateIsLoaded_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        sut.state = .loaded

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(repo.calls.count, 0)
        XCTAssertEqual(sut.state, .loaded)
        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls.count, 0)
    }

    func test_loadIfNeeded_givenStateIsFailed_whenCalled_thenDoesNotRequestRepository() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()
        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        sut.state = .failed(message: "Anything")

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(repo.calls.count, 0)
        XCTAssertEqual(sut.state, .failed(message: "Anything"))
        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls.count, 0)
    }

    // MARK: - Tests (Load)

    func test_load_givenRepositorySuccess_setsLoaded_setsModel_andSetsIsInTeamFromStore() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(false)

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(repo.calls.count, 1)
        XCTAssertEqual(repo.calls.first?.name, "scizor")
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.model?.name.lowercased(), "scizor")
        XCTAssertEqual(sut.isInTeam, false)

        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls, [model.id])
    }

    func test_load_givenRepositoryFailure_setsFailed_andDoesNotSetModel_andDoesNotCheckContains() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()
        repo.stubbedResult = .failure(anyError())

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(repo.calls.count, 1)
        XCTAssertEqual(sut.state, .failed(message: "Something went wrong"))
        XCTAssertNil(sut.model)

        let containsCalls = await teamStore.containsCalls
        XCTAssertEqual(containsCalls.count, 0)
    }

    // MARK: - Tests (Confirm Flow)

    func test_didTapTeamAction_whenModelIsNil_doesNothing() {
        // Given
        let sut = makeSUT(pokemonName: "Scizor")
        XCTAssertNil(sut.model)

        // When
        sut.didTapTeamAction()

        // Then
        XCTAssertEqual(sut.isConfirmPresented, false)
    }

    func test_didTapTeamAction_whenNotInTeam_setsConfirmPresented() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(false)

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        await sut.load()
        XCTAssertEqual(sut.isInTeam, false)

        // When
        sut.didTapTeamAction()

        // Then
        XCTAssertEqual(sut.isConfirmPresented, true)
    }

    func test_confirmTeamAction_whenAddSucceeds_setsIsInTeamTrue_andShowsSuccessToast() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(false)

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        await sut.load()

        sut.didTapTeamAction()
        XCTAssertEqual(sut.isConfirmPresented, true)

        // When
        await sut.confirmTeamAction()

        // Then
        XCTAssertEqual(sut.isConfirmPresented, false)
        XCTAssertEqual(sut.isInTeam, true)
        XCTAssertNil(sut.teamErrorMessage)

        let saveCalls = await teamStore.saveCalls
        XCTAssertEqual(saveCalls.map(\.id), [model.id])

        XCTAssertEqual(sut.feedbackToast?.style, .success)
        XCTAssertEqual(sut.feedbackToast?.title, "Added to team")
    }

    func test_confirmTeamAction_whenRemoveSucceeds_setsIsInTeamFalse_andShowsSuccessToast() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(true)

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        await sut.load()

        XCTAssertEqual(sut.isInTeam, true)
        sut.didTapTeamAction()

        // When
        await sut.confirmTeamAction()

        // Then
        XCTAssertEqual(sut.isInTeam, false)
        XCTAssertNil(sut.teamErrorMessage)

        let deleteCalls = await teamStore.deleteCalls
        XCTAssertEqual(deleteCalls, [model.id])

        XCTAssertEqual(sut.feedbackToast?.style, .success)
        XCTAssertEqual(sut.feedbackToast?.title, "Removed from team")
    }

    func test_confirmTeamAction_whenTeamIsFull_setsErrorMessage_andShowsErrorToast_andDoesNotSetIsInTeamTrue() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(false)
        await teamStore.stubSaveError(.teamIsFull(max: 6))

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        await sut.load()

        sut.didTapTeamAction()

        // When
        await sut.confirmTeamAction()

        // Then
        XCTAssertEqual(sut.isInTeam, false)
        XCTAssertEqual(sut.teamErrorMessage, "Your team is full (max 6).")
        XCTAssertEqual(sut.feedbackToast?.style, .error)
        XCTAssertEqual(sut.feedbackToast?.title, "Action failed")
    }

    func test_confirmTeamAction_whenAlreadyExists_setsIsInTeamTrue_setsErrorMessage_andShowsErrorToast() async {
        // Given
        let repo = PokemonDetailsRepositorySpy()
        let teamStore = TeamPokemonStoreSpy()

        let model = PokemonDetailsFixture.model(name: "scizor")
        repo.stubbedResult = .success(model)
        await teamStore.stubContainsResult(false)
        await teamStore.stubSaveError(.alreadyExists)

        let sut = makeSUT(pokemonName: "Scizor", repository: repo, teamStore: teamStore)
        await sut.load()

        sut.didTapTeamAction()

        // When
        await sut.confirmTeamAction()

        // Then
        XCTAssertEqual(sut.isInTeam, true)
        XCTAssertEqual(sut.teamErrorMessage, "This Pokémon is already in your team.")
        XCTAssertEqual(sut.feedbackToast?.style, .error)
        XCTAssertEqual(sut.feedbackToast?.title, "Action failed")
    }

    func test_dismissToast_setsFeedbackToastToNil() async {
        // Given
        let sut = makeSUT(pokemonName: "Scizor")
        sut.feedbackToast = .init(title: "x", message: "y", style: .success)
        XCTAssertNotNil(sut.feedbackToast)

        // When
        sut.dismissToast()

        // Then
        XCTAssertNil(sut.feedbackToast)
    }

    // MARK: - Helpers

    private func makeSUT(
        pokemonName: String,
        repository: PokemonDetailsRepository = PokemonDetailsRepositorySpy(),
        teamStore: TeamPokemonStore = TeamPokemonStoreSpy()
    ) -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(
            pokemonName: pokemonName,
            repository: repository,
            teamStore: teamStore
        )
    }

    private func anyError() -> NSError {
        NSError(domain: "PokemonDetailsViewModelTests", code: 0)
    }
}

// MARK: - Spy (Repository)

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

// MARK: - Spy (Team Store) - same file

private actor TeamPokemonStoreSpy: TeamPokemonStore {

    private(set) var fetchCallsCount: Int = 0
    private(set) var saveCalls: [TeamPokemon] = []
    private(set) var deleteCalls: [Int] = []
    private(set) var containsCalls: [Int] = []

    private var stubbedContains: Bool = false
    private var stubbedFetch: [TeamPokemon] = []
    private var stubbedSaveError: TeamPokemonStoreError?
    private var stubbedDeleteError: Error?
    private var stubbedContainsError: Error?

    func stubContainsResult(_ value: Bool) {
        stubbedContains = value
    }

    func stubFetchResult(_ value: [TeamPokemon]) {
        stubbedFetch = value
    }

    func stubSaveError(_ error: TeamPokemonStoreError?) {
        stubbedSaveError = error
    }

    func stubDeleteError(_ error: Error?) {
        stubbedDeleteError = error
    }

    func stubContainsError(_ error: Error?) {
        stubbedContainsError = error
    }

    func fetchTeam() async throws -> [TeamPokemon] {
        fetchCallsCount += 1
        return stubbedFetch
    }

    func save(_ pokemon: TeamPokemon) async throws {
        if let stubbedSaveError {
            throw stubbedSaveError
        }
        saveCalls.append(pokemon)
    }

    func delete(memberId: Int) async throws {
        if let stubbedDeleteError {
            throw stubbedDeleteError
        }
        deleteCalls.append(memberId)
    }

    func contains(memberId: Int) async throws -> Bool {
        if let stubbedContainsError {
            throw stubbedContainsError
        }
        containsCalls.append(memberId)
        return stubbedContains
    }
}
