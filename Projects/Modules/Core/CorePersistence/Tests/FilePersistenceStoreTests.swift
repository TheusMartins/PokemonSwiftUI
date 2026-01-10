//
//  FilePersistenceStoreTests.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import XCTest
@testable import CorePersistence

final class FilePersistenceStoreTests: XCTestCase {

    func test_init_createsDirectoryIfNeeded() async throws {
        // Given
        let persistor = FilePersistorSpy()

        // When
        _ = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )
        
        let persistorResult = await persistor.createdDirectories.count

        // Then
        XCTAssertEqual(persistorResult, 1)
    }

    func test_save_thenLoad_returnsSavedData() async throws {
        // Given
        let (sut, persistor) = try await makeSUT()
        let key = PersistenceKey("k1")
        let expected = Data("hello".utf8)

        // When
        try await sut.save(expected, for: key)
        let loaded = try await sut.load(for: key)
        
        let persistorResult = await persistor.writeCallCount

        // Then
        XCTAssertEqual(loaded, expected)
        XCTAssertEqual(persistorResult, 1)
    }

    func test_load_whenNoFile_returnsNil() async throws {
        // Given
        let (sut, _) = try await makeSUT()

        // When
        let loaded = try await sut.load(for: .init("missing"))

        // Then
        XCTAssertNil(loaded)
    }

    func test_remove_forKey_deletesFile() async throws {
        // Given
        let (sut, _) = try await makeSUT()
        let key = PersistenceKey("k1")

        try await sut.save(Data("x".utf8), for: key)

        // When
        try await sut.remove(for: key)
        let loaded = try await sut.load(for: key)

        // Then
        XCTAssertNil(loaded)
    }

    func test_removeAll_clearsDirectoryContents() async throws {
        // Given
        let (sut, persistor) = try await makeSUT()
        try await sut.save(Data("1".utf8), for: .init("k1"))
        try await sut.save(Data("2".utf8), for: .init("k2"))

        // When
        try await sut.removeAll()
        let persistorResult = await persistor.removeContentsOfDirectoryCalls
        let result1 = try await sut.load(for: .init("k1"))
        let result2 = try await sut.load(for: .init("k2"))

        // Then
        XCTAssertEqual(persistorResult , 1)
        XCTAssertNil(result1)
        XCTAssertNil(result2)
    }

    func test_save_whenWriteThrows_propagatesError() async throws {
        // Given
        let writeError = NSError(domain: "test", code: 1)
        let persistor = FilePersistorSpy()
        await persistor.setWriteError(writeError)

        let sut = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )

        // When / Then
        do {
            try await sut.save(Data("x".utf8), for: .init("k"))
            XCTFail("Expected to throw")
        } catch {
            let ns = error as NSError
            XCTAssertEqual(ns.domain, writeError.domain)
            XCTAssertEqual(ns.code, writeError.code)
        }
    }

    func test_load_whenReadThrows_propagatesError() async throws {
        // Given
        let readError = NSError(domain: "test", code: 2)
        let persistor = FilePersistorSpy()
        await persistor.setReadError(readError)

        let sut = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )

        // When / Then
        do {
            _ = try await sut.load(for: .init("k"))
            XCTFail("Expected to throw")
        } catch {
            let ns = error as NSError
            XCTAssertEqual(ns.domain, readError.domain)
            XCTAssertEqual(ns.code, readError.code)
        }
    }

    func test_remove_whenRemoveThrows_propagatesError() async throws {
        // Given
        let removeError = NSError(domain: "test", code: 3)
        let persistor = FilePersistorSpy()
        await persistor.setRemoveError(removeError)

        let sut = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )

        // When / Then
        do {
            try await sut.remove(for: .init("k"))
            XCTFail("Expected to throw")
        } catch {
            let ns = error as NSError
            XCTAssertEqual(ns.domain, removeError.domain)
            XCTAssertEqual(ns.code, removeError.code)
        }
    }

    func test_removeAll_whenRemoveContentsThrows_propagatesError() async throws {
        // Given
        let removeAllError = NSError(domain: "test", code: 4)
        let persistor = FilePersistorSpy()
        await persistor.setRemoveContentsError(removeAllError)

        let sut = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )

        // When / Then
        do {
            try await sut.removeAll()
            XCTFail("Expected to throw")
        } catch {
            let ns = error as NSError
            XCTAssertEqual(ns.domain, removeAllError.domain)
            XCTAssertEqual(ns.code, removeAllError.code)
        }
    }

    // MARK: - Helpers

    private func makeSUT() async throws -> (FilePersistenceStore, FilePersistorSpy) {
        let persistor = FilePersistorSpy()

        let sut = try await FilePersistenceStore(
            directory: .caches,
            filePersistor: persistor,
            fileManager: FileManagerStub(baseURL: URL(fileURLWithPath: "/tmp/CorePersistenceTests"))
        )

        return (sut, persistor)
    }
}

// MARK: - Spies / Stubs

private actor FilePersistorSpy: FilePersisting {
    private var storage: [URL: Data] = [:]

    private(set) var createdDirectories: [URL] = []
    private(set) var removedItems: [URL] = []
    private(set) var removeContentsOfDirectoryCalls: Int = 0
    private(set) var writeCallCount: Int = 0

    private var readError: Error?
    private var writeError: Error?
    private var removeError: Error?
    private var createDirectoryError: Error?
    private var removeContentsError: Error?

    func setReadError(_ error: Error?) { readError = error }
    func setWriteError(_ error: Error?) { writeError = error }
    func setRemoveError(_ error: Error?) { removeError = error }
    func setCreateDirectoryError(_ error: Error?) { createDirectoryError = error }
    func setRemoveContentsError(_ error: Error?) { removeContentsError = error }

    func contents(at url: URL) async throws -> Data? {
        if let readError { throw readError }
        return storage[url]
    }

    func write(_ data: Data, to url: URL) async throws {
        if let writeError { throw writeError }
        writeCallCount += 1
        storage[url] = data
    }

    func removeItem(at url: URL) async throws {
        if let removeError { throw removeError }
        removedItems.append(url)
        storage[url] = nil
    }

    func createDirectoryIfNeeded(at url: URL) async throws {
        if let createDirectoryError { throw createDirectoryError }
        createdDirectories.append(url)
    }

    func removeContentsOfDirectory(at url: URL) async throws {
        if let removeContentsError { throw removeContentsError }
        removeContentsOfDirectoryCalls += 1

        storage.keys
            .filter { $0.path.hasPrefix(url.path) }
            .forEach { storage[$0] = nil }
    }
}

private final class FileManagerStub: FileManager {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
        super.init()
    }

    override func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        [baseURL]
    }
}
