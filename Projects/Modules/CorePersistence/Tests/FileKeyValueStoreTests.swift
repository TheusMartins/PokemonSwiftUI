//
//  FileKeyValueStoreTests.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import XCTest
@testable import CorePersistence

final class FileKeyValueStoreTests: XCTestCase {

    // MARK: - Tests

    func test_init_createsDirectoryIfNeeded() async throws {
        // Given
        let persistor = FilePersistorSpy()

        // When
        _ = try await makeSUT(persistor: persistor)

        // Then
        let callCount = await persistor.getCreateDirectoryCallsCount()
        XCTAssertEqual(callCount, 1)
    }

    func test_set_thenGet_returnsSameData() async throws {
        // Given
        let persistor = FilePersistorSpy()
        let sut = try await makeSUT(persistor: persistor)
        let key = PersistenceKey("pokemonTeam")
        let expected = Data("scizor".utf8)

        // When
        try await sut.set(expected, for: key)
        let received = try await sut.get(for: key)

        // Then
        XCTAssertEqual(received, expected)
    }

    func test_get_givenNoFile_returnsNil() async throws {
        // Given
        let persistor = FilePersistorSpy()
        let sut = try await makeSUT(persistor: persistor)

        // When
        let received = try await sut.get(for: PersistenceKey("missing"))

        // Then
        XCTAssertNil(received)
    }

    func test_remove_deletesItem() async throws {
        // Given
        let persistor = FilePersistorSpy()
        let sut = try await makeSUT(persistor: persistor)
        let key = PersistenceKey("pokemonTeam")

        try await sut.set(Data("bulbasaur".utf8), for: key)

        // When
        try await sut.remove(for: key)
        let received = try await sut.get(for: key)
        let callCount = await persistor.getCreateDirectoryCallsCount()

        // Then
        XCTAssertNil(received)
        XCTAssertEqual(callCount, 1)
    }

    func test_removeAll_deletesDirectoryAndRecreates() async throws {
        // Given
        let persistor = FilePersistorSpy()
        let sut = try await makeSUT(persistor: persistor)

        // When
        try await sut.removeAll()

        // Then
        let callCount = await persistor.getCreateDirectoryCallsCount()
        let deleteCallsCount = await persistor.deleteCallsCount
        XCTAssertEqual(deleteCallsCount, 1)
        XCTAssertEqual(callCount, 2) // 1 no init + 1 no removeAll
    }

    // MARK: - Helpers

    private func makeSUT(persistor: FilePersistorSpy) async throws -> FileKeyValueStore {
        try await FileKeyValueStore(
            directory: .caches,
            persistor: persistor,
            fileManager: .default
        )
    }
}

// MARK: - Spy (same file)

private actor FilePersistorSpy: FilePersisting {

    private var storage: [URL: Data] = [:]
    private var existingDirectories: Set<URL> = []

    private var createDirectoryCallsCount: Int = 0
    private(set) var deleteCallsCount: Int = 0

    // MARK: - Read-only accessors (fix actor isolation)

    func getCreateDirectoryCallsCount() -> Int { createDirectoryCallsCount }
    func getDeleteCallsCount() -> Int { deleteCallsCount }

    // MARK: - FilePersisting

    func read(from url: URL) async throws -> Data? {
        storage[url]
    }

    func write(_ data: Data, to url: URL) async throws {
        storage[url] = data
    }

    func delete(at url: URL) async throws {
        deleteCallsCount += 1

        let prefix = url.absoluteString
        storage = storage.filter { !$0.key.absoluteString.hasPrefix(prefix) }
        existingDirectories.remove(url)
    }

    func createDirectoryIfNeeded(at url: URL) async throws {
        createDirectoryCallsCount += 1
        existingDirectories.insert(url)
    }
}
