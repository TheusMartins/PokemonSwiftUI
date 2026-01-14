//
//  InMemoryImageCacheTests.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import XCTest
@testable import CoreRemoteImage

final class InMemoryImageCacheTests: XCTestCase {

    func test_data_forKey_whenEmpty_returnsNil() async {
        // Given
        let sut = InMemoryImageCache()

        // When
        let result = await sut.data(forKey: "missing-key")

        // Then
        XCTAssertNil(result)
    }

    func test_insert_thenData_forKey_returnsInsertedData() async {
        // Given
        let sut = InMemoryImageCache()
        let expected = Data("image-bytes".utf8)

        // When
        await sut.insert(expected, forKey: "key")
        let result = await sut.data(forKey: "key")

        // Then
        XCTAssertEqual(result, expected)
    }

    func test_remove_forKey_removesInsertedData() async {
        // Given
        let sut = InMemoryImageCache()
        let expected = Data("image-bytes".utf8)
        await sut.insert(expected, forKey: "key")

        // When
        await sut.remove(forKey: "key")
        let result = await sut.data(forKey: "key")

        // Then
        XCTAssertNil(result)
    }

    func test_insertNil_forKey_removesValue() async {
        // Given
        let sut = InMemoryImageCache()
        let expected = Data("image-bytes".utf8)
        await sut.insert(expected, forKey: "key")

        // When
        await sut.insert(nil, forKey: "key")
        let result = await sut.data(forKey: "key")

        // Then
        XCTAssertNil(result)
    }

    func test_removeAll_clearsCache() async {
        // Given
        let sut = InMemoryImageCache()
        await sut.insert(Data("1".utf8), forKey: "k1")
        await sut.insert(Data("2".utf8), forKey: "k2")

        // When
        await sut.removeAll()

        // Then
        let result1 = await sut.data(forKey: "k1")
        let result2 = await sut.data(forKey: "k2")
        XCTAssertNil(result1)
        XCTAssertNil(result2)
    }

    func test_insert_differentKeys_storeIndependentValues() async {
        // Given
        let sut = InMemoryImageCache()
        let data1 = Data("a".utf8)
        let data2 = Data("b".utf8)

        // When
        await sut.insert(data1, forKey: "k1")
        await sut.insert(data2, forKey: "k2")
        
        let result1 = await sut.data(forKey: "k1")
        let result2 = await sut.data(forKey: "k2")

        // Then
        XCTAssertEqual(result1, data1)
        XCTAssertEqual(result2, data2)
    }
}
