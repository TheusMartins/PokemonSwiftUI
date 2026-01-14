//
//  DefaultJSONStoreTests.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import XCTest
@testable import CorePersistence

final class DefaultJSONStoreTests: XCTestCase {

    // MARK: - Tests

    func test_set_givenEncodable_whenCalled_thenStoresEncodedData() async throws {
        // Given
        let kvSpy = KeyValueStoreSpy()
        let coder = JSONCoderSpy()
        coder.stubbedEncodeResult = .success(Data("encoded".utf8))

        let sut = makeSUT(store: kvSpy, coder: coder)
        let key = PersistenceKey("any-key")

        // When
        try await sut.set(DummyEncodable(value: "pikachu"), for: key)

        // Then
        XCTAssertEqual(coder.encodeCallsCount, 1)
        XCTAssertEqual(kvSpy.setCalls.count, 1)
        XCTAssertEqual(kvSpy.setCalls.first?.key, key)
        XCTAssertEqual(kvSpy.setCalls.first?.data, Data("encoded".utf8))
    }

    func test_set_givenCoderThrows_whenCalled_thenThrowsAndDoesNotCallStore() async {
        // Given
        let kvSpy = KeyValueStoreSpy()
        let coder = JSONCoderSpy()
        coder.stubbedEncodeResult = .failure(DummyError.any)

        let sut = makeSUT(store: kvSpy, coder: coder)
        let key = PersistenceKey("any-key")

        // When / Then
        do {
            try await sut.set(DummyEncodable(value: "pikachu"), for: key)
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
            XCTAssertTrue(kvSpy.setCalls.isEmpty)
        }
    }

    func test_get_givenNoDataInStore_whenCalled_thenReturnsNilAndDoesNotDecode() async throws {
        // Given
        let kvSpy = KeyValueStoreSpy()
        kvSpy.stubbedGetResult = .success(nil)

        let coder = JSONCoderSpy()
        let sut = makeSUT(store: kvSpy, coder: coder)

        // When
        let result = try await sut.get(DummyDecodable.self, for: PersistenceKey("missing"))

        // Then
        XCTAssertNil(result)
        XCTAssertEqual(coder.decodeCallsCount, 0)
    }

    func test_get_givenDataInStore_whenDecodeSucceeds_thenReturnsDecodedValue() async throws {
        // Given
        let kvSpy = KeyValueStoreSpy()
        kvSpy.stubbedGetResult = .success(Data("payload".utf8))

        let coder = JSONCoderSpy()
        coder.stubbedDecodeResult = .success(DummyDecodable(value: "scizor"))

        let sut = makeSUT(store: kvSpy, coder: coder)

        // When
        let result = try await sut.get(DummyDecodable.self, for: PersistenceKey("any"))

        // Then
        XCTAssertEqual(result?.value, "scizor")
        XCTAssertEqual(coder.decodeCallsCount, 1)
    }

    func test_get_givenStoreThrows_whenCalled_thenThrowsAndDoesNotDecode() async {
        // Given
        let kvSpy = KeyValueStoreSpy()
        kvSpy.stubbedGetResult = .failure(DummyError.any)

        let coder = JSONCoderSpy()
        let sut = makeSUT(store: kvSpy, coder: coder)

        // When / Then
        do {
            _ = try await sut.get(DummyDecodable.self, for: PersistenceKey("any"))
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
            XCTAssertEqual(coder.decodeCallsCount, 0)
        }
    }

    func test_get_givenDecodeThrows_whenCalled_thenThrows() async {
        // Given
        let kvSpy = KeyValueStoreSpy()
        kvSpy.stubbedGetResult = .success(Data("payload".utf8))

        let coder = JSONCoderSpy()
        coder.stubbedDecodeResult = .failure(DummyError.any)

        let sut = makeSUT(store: kvSpy, coder: coder)

        // When / Then
        do {
            _ = try await sut.get(DummyDecodable.self, for: PersistenceKey("any"))
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }

    func test_remove_whenCalled_thenDelegatesToStore() async throws {
        // Given
        let kvSpy = KeyValueStoreSpy()
        let sut = makeSUT(store: kvSpy, coder: JSONCoderSpy())
        let key = PersistenceKey("pokemonTeam")

        // When
        try await sut.remove(for: key)

        // Then
        XCTAssertEqual(kvSpy.removeCalls, [key])
    }

    // MARK: - Helpers

    private func makeSUT(
        store: KeyValueStoreSpy = KeyValueStoreSpy(),
        coder: JSONCoding = JSONCoderSpy()
    ) -> DefaultJSONStore {
        DefaultJSONStore(store: store, coder: coder)
    }
}

// MARK: - Spies & Fixtures (same file)

private final class KeyValueStoreSpy: KeyValueStoring {

    struct SetCall: Equatable {
        let data: Data
        let key: PersistenceKey
    }

    var setCalls: [SetCall] = []
    var removeCalls: [PersistenceKey] = []

    var stubbedGetResult: Result<Data?, Error> = .success(nil)

    func set(_ data: Data, for key: PersistenceKey) async throws {
        setCalls.append(.init(data: data, key: key))
    }

    func get(for key: PersistenceKey) async throws -> Data? {
        try stubbedGetResult.get()
    }

    func remove(for key: PersistenceKey) async throws {
        removeCalls.append(key)
    }

    func removeAll() async throws { }
}

private final class JSONCoderSpy: JSONCoding {

    var encodeCallsCount: Int = 0
    var decodeCallsCount: Int = 0

    var stubbedEncodeResult: Result<Data, Error> = .success(Data())
    var stubbedDecodeResult: Result<Any, Error> = .failure(DummyError.any)

    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        encodeCallsCount += 1
        return try stubbedEncodeResult.get()
    }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodeCallsCount += 1
        let any = try stubbedDecodeResult.get()
        guard let casted = any as? T else {
            fatalError("JSONCoderSpy: stubbedDecodeResult must contain \(T.self)")
        }
        return casted
    }
}

private struct DummyEncodable: Encodable, Equatable {
    let value: String
}

private struct DummyDecodable: Decodable, Equatable {
    let value: String
}

private enum DummyError: Error {
    case any
}
