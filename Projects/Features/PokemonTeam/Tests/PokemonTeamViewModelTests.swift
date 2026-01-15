//
//  PokemonTeamViewModelTests.swift
//  PokemonTeamTests
//
//  Created by Matheus Martins on 15/01/26.
//

import XCTest
import CorePersistence
@testable import PokemonTeam

@MainActor
final class PokemonTeamViewModelTests: XCTestCase {

    // MARK: - Tests: loadIfNeeded

    func test_loadIfNeeded_whenStateIsIdle_loadsTeamAndUpdatesStateToLoaded() async {
        // Given
        let pokemon = anyTeamPokemon(id: 1, name: "Pikachu")
        let store = TeamPokemonStoreSpy()
        store.fetchTeamResult = .success([pokemon])

        let sut = makeSUT(store: store)
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.members.isEmpty)

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(store.fetchTeamCallCount, 1)
        XCTAssertEqual(sut.members, [pokemon])
        XCTAssertEqual(sut.state, .loaded)
    }

    func test_loadIfNeeded_whenStateIsNotIdle_doesNotLoad() async {
        // Given
        let store = TeamPokemonStoreSpy()
        store.fetchTeamResult = .success([anyTeamPokemon(id: 1)])

        let sut = makeSUT(store: store)
        sut.state = .loaded

        // When
        await sut.loadIfNeeded()

        // Then
        XCTAssertEqual(store.fetchTeamCallCount, 0)
        XCTAssertTrue(sut.members.isEmpty)
        XCTAssertEqual(sut.state, .loaded)
    }

    // MARK: - Tests: load

    func test_load_whenSuccess_updatesMembersAndStateToLoaded() async {
        // Given
        let pokemon1 = anyTeamPokemon(id: 10, name: "Charizard")
        let pokemon2 = anyTeamPokemon(id: 20, name: "Blastoise")

        let store = TeamPokemonStoreSpy()
        store.fetchTeamResult = .success([pokemon1, pokemon2])

        let sut = makeSUT(store: store)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(store.fetchTeamCallCount, 1)
        XCTAssertEqual(sut.members, [pokemon1, pokemon2])
        XCTAssertEqual(sut.state, .loaded)
    }

    func test_load_whenFailure_updatesStateToFailedWithGenericMessage_andKeepsMembersEmpty() async {
        // Given
        let store = TeamPokemonStoreSpy()
        store.fetchTeamResult = .failure(anyError())

        let sut = makeSUT(store: store)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(store.fetchTeamCallCount, 1)
        XCTAssertTrue(sut.members.isEmpty)

        guard case .failed(let message) = sut.state else {
            return XCTFail("Expected state to be failed")
        }
        XCTAssertEqual(message, "Something went wrong")
    }

    // MARK: - Tests: delete

    func test_delete_whenSuccess_deletesThenRefetches_updatesMembersAndStateToLoaded() async {
        // Given
        let memberIdToDelete = 999

        let pokemonAfterDelete1 = anyTeamPokemon(id: 1, name: "Scizor")
        let pokemonAfterDelete2 = anyTeamPokemon(id: 2, name: "Lucario")

        let store = TeamPokemonStoreSpy()
        store.deleteResult = .success(())
        store.fetchTeamResult = .success([pokemonAfterDelete1, pokemonAfterDelete2])

        let sut = makeSUT(store: store)

        // When
        await sut.delete(memberId: memberIdToDelete)

        // Then
        XCTAssertEqual(store.deleteCallCount, 1)
        XCTAssertEqual(store.deleteReceivedMemberIds, [memberIdToDelete])

        XCTAssertEqual(store.fetchTeamCallCount, 1)
        XCTAssertEqual(sut.members, [pokemonAfterDelete1, pokemonAfterDelete2])
        XCTAssertEqual(sut.state, .loaded)
    }

    func test_delete_whenDeleteFails_updatesStateToFailedWithGenericMessage_andDoesNotRefetch() async {
        // Given
        let store = TeamPokemonStoreSpy()
        store.deleteResult = .failure(anyError())
        store.fetchTeamResult = .success([anyTeamPokemon(id: 1)]) // should not be used

        let sut = makeSUT(store: store)

        // When
        await sut.delete(memberId: 123)

        // Then
        XCTAssertEqual(store.deleteCallCount, 1)
        XCTAssertEqual(store.fetchTeamCallCount, 0)

        guard case .failed(let message) = sut.state else {
            return XCTFail("Expected state to be failed")
        }
        XCTAssertEqual(message, "Something went wrong")
    }

    func test_delete_whenRefetchFails_updatesStateToFailedWithGenericMessage() async {
        // Given
        let store = TeamPokemonStoreSpy()
        store.deleteResult = .success(())
        store.fetchTeamResult = .failure(anyError())

        let sut = makeSUT(store: store)

        // When
        await sut.delete(memberId: 123)

        // Then
        XCTAssertEqual(store.deleteCallCount, 1)
        XCTAssertEqual(store.fetchTeamCallCount, 1)

        guard case .failed(let message) = sut.state else {
            return XCTFail("Expected state to be failed")
        }
        XCTAssertEqual(message, "Something went wrong")
    }

    // MARK: - Helpers

    private func makeSUT(
        store: TeamPokemonStoreSpy,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> PokemonTeamViewModel {
        let sut = PokemonTeamViewModel(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return sut
    }
}

// MARK: - Spy

@MainActor
final class TeamPokemonStoreSpy: TeamPokemonStore {

    private(set) var fetchTeamCallCount = 0
    var fetchTeamResult: Result<[TeamPokemon], Error> = .success([])

    private(set) var deleteCallCount = 0
    private(set) var deleteReceivedMemberIds: [Int] = []
    var deleteResult: Result<Void, Error> = .success(())

    // These are not used by PokemonTeamViewModel, but required by the protocol.
    var saveResult: Result<Void, Error> = .success(())
    var containsResult: Result<Bool, Error> = .success(false)

    func fetchTeam() async throws -> [TeamPokemon] {
        fetchTeamCallCount += 1
        return try fetchTeamResult.get()
    }

    func delete(memberId: Int) async throws {
        deleteCallCount += 1
        deleteReceivedMemberIds.append(memberId)
        try deleteResult.get()
    }

    func save(_ pokemon: TeamPokemon) async throws {
        try saveResult.get()
    }

    func contains(memberId: Int) async throws -> Bool {
        return try containsResult.get()
    }
}

// MARK: - Test Helpers

private func anyError() -> NSError {
    NSError(domain: "PokemonTeamTests", code: 1)
}

private func anyTeamPokemon(
    id: Int,
    name: String = "Pikachu"
) -> TeamPokemon {
    TeamPokemon(
        id: id,
        name: name,
        spriteURL: URL(string: "https://example.com/\(id).png"),
        types: [],
        stats: []
    )
}

// MARK: - Memory Leaks

private extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Potential memory leak. Instance should have been deallocated.",
                file: file,
                line: line
            )
        }
    }
}
