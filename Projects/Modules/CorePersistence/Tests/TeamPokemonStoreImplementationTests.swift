//
//  TeamPokemonStoreImplementationTests.swift
//  CorePersistence
//
//  Created by Matheus Martins on 13/01/26.
//

import XCTest
@testable import CorePersistence

final class TeamPokemonStoreImplementationTests: XCTestCase {
    func test_fetchTeam_whenNoData_returnsEmpty() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        // When
        let team = try await sut.fetchTeam()

        // Then
        XCTAssertEqual(team, [])
        let getCount = await keyValue.getCallsCount()
        XCTAssertEqual(getCount, 1)
    }

    func test_save_appendsPokemon_andPersists() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        let p1 = makePokemon(id: 212, name: "Scizor")

        // When
        try await sut.save(p1)
        let team = try await sut.fetchTeam()

        // Then
        XCTAssertEqual(team, [p1])

        let setCount = await keyValue.setCallsCount()
        XCTAssertEqual(setCount, 1)
    }

    func test_save_whenAlreadyExists_throwsAlreadyExists_andDoesNotPersist() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        let p1 = makePokemon(id: 212, name: "Scizor")
        try await sut.save(p1)

        // When
        do {
            try await sut.save(p1)
            XCTFail("Expected to throw alreadyExists")
        } catch let error as TeamPokemonStoreError {
            // Then
            XCTAssertEqual(error, .alreadyExists)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        let setCount = await keyValue.setCallsCount()
        XCTAssertEqual(setCount, 1, "Should only persist once (first save)")
    }

    func test_save_whenTeamIsFull_throwsTeamIsFull_andDoesNotPersistNewMember() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue, maxTeamSize: 2)

        let p1 = makePokemon(id: 1, name: "Bulbasaur")
        let p2 = makePokemon(id: 4, name: "Charmander")
        let p3 = makePokemon(id: 7, name: "Squirtle")

        try await sut.save(p1)
        try await sut.save(p2)

        // When
        do {
            try await sut.save(p3)
            XCTFail("Expected to throw teamIsFull")
        } catch let error as TeamPokemonStoreError {
            // Then
            XCTAssertEqual(error, .teamIsFull(max: 2))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        let team = try await sut.fetchTeam()
        XCTAssertEqual(team, [p1, p2])

        let setCount = await keyValue.setCallsCount()
        XCTAssertEqual(setCount, 2, "Should not persist when full")
    }

    func test_delete_removesMember_andPersistsUpdatedTeam() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        let p1 = makePokemon(id: 212, name: "Scizor")
        let p2 = makePokemon(id: 472, name: "Gliscor")

        try await sut.save(p1)
        try await sut.save(p2)

        // When
        try await sut.delete(memberId: 212)
        let team = try await sut.fetchTeam()

        // Then
        XCTAssertEqual(team, [p2])

        let setCount = await keyValue.setCallsCount()
        XCTAssertEqual(setCount, 3, "2 saves + 1 delete persist")
    }

    func test_contains_whenMemberExists_returnsTrue() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        let p1 = makePokemon(id: 212, name: "Scizor")
        try await sut.save(p1)

        // When
        let contains = try await sut.contains(memberId: 212)

        // Then
        XCTAssertTrue(contains)
    }

    func test_contains_whenMemberDoesNotExist_returnsFalse() async throws {
        // Given
        let keyValue = KeyValueStoreSpy()
        let sut = makeSUT(keyValueStore: keyValue)

        let p1 = makePokemon(id: 212, name: "Scizor")
        try await sut.save(p1)

        // When
        let contains = try await sut.contains(memberId: 999)

        // Then
        XCTAssertFalse(contains)
    }

    // MARK: - Helpers

    private func makeSUT(
        keyValueStore: KeyValueStoring,
        maxTeamSize: Int = 6,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TeamPokemonStoreImplementation {
        let sut = TeamPokemonStoreImplementation.make(
            keyValueStore: keyValueStore,
            coder: TestJSONCoder(),
            key: .pokemonTeam,
            maxTeamSize: maxTeamSize
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func makePokemon(id: Int, name: String) -> TeamPokemon {
        TeamPokemon(
            id: id,
            name: name,
            spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"),
            types: [.bug],
            stats: [
                .init(kind: .hp, value: 70),
                .init(kind: .attack, value: 130),
                .init(kind: .defense, value: 100),
                .init(kind: .specialAttack, value: 55),
                .init(kind: .specialDefense, value: 80),
                .init(kind: .speed, value: 65)
            ]
        )
    }

    private func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString,
        line: UInt
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak.", file: file, line: line)
        }
    }
}

// MARK: - Spies / Test Doubles (same file)

private actor KeyValueStoreSpy: KeyValueStoring {

    private var storage: [PersistenceKey: Data] = [:]

    private var getCount: Int = 0
    private var setCount: Int = 0
    private var removeCount: Int = 0
    private var removeAllCount: Int = 0

    func set(_ data: Data, for key: PersistenceKey) async throws {
        setCount += 1
        storage[key] = data
    }

    func get(for key: PersistenceKey) async throws -> Data? {
        getCount += 1
        return storage[key]
    }

    func remove(for key: PersistenceKey) async throws {
        removeCount += 1
        storage[key] = nil
    }

    func removeAll() async throws {
        removeAllCount += 1
        storage.removeAll()
    }

    // Async getters for assertions (avoid actor-isolated property errors)
    func getCallsCount() -> Int { getCount }
    func setCallsCount() -> Int { setCount }
    func removeCallsCount() -> Int { removeCount }
    func removeAllCallsCount() -> Int { removeAllCount }
}

private struct TestJSONCoder: JSONCoding {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func encode<T: Encodable>(_ value: T) throws -> Data {
        try encoder.encode(value)
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
}
