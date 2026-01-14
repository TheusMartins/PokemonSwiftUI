//
//  RemoteImageLoaderTests.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import XCTest
import SwiftUI
@testable import CoreRemoteImage
import CoreNetworking

final class RemoteImageLoaderTests: XCTestCase {

    func test_loadImage_whenCacheHasData_returnsWithoutCallingRequester() async throws {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        let cachedData = UIImage(systemName: "star")!.pngData()!

        let cache = ImageCacheSpy()
        await cache.insert(cachedData, forKey: url.absoluteString)

        let requester = RequesterSpy()
        let sut = RemoteImageLoader(
            requester: requester,
            cache: cache
        )

        // When
        _ = try await sut.loadImageData(from: url)

        // Then
        XCTAssertEqual(requester.callCount, 0)
    }

    func test_loadImage_whenStatusCodeIsNot2xx_throwsInvalidStatusCode() async {
        // Given
        let url = URL(string: "https://example.com/image.png")!

        let requester = RequesterSpy()
        requester.result = .success(
            RequestSuccessResponse(
                data: Data(),
                response: HTTPURLResponse(
                    url: url,
                    statusCode: 404,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        )

        let sut = RemoteImageLoader(
            requester: requester,
            cache: InMemoryImageCache()
        )

        // When / Then
        do {
            _ = try await sut.loadImageData(from: url)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(error as? RemoteImageError, .invalidStatusCode(404))
        }
    }

    func test_loadImage_whenDataIsNotAnImage_throwsInvalidImageData() async {
        // Given
        let url = URL(string: "https://example.com/image.png")!

        let requester = RequesterSpy()
        requester.result = .success(
            RequestSuccessResponse(
                data: Data("not-an-image".utf8),
                response: HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        )

        let sut = RemoteImageLoader(
            requester: requester,
            cache: InMemoryImageCache()
        )

        // When / Then
        do {
            _ = try await sut.loadImageData(from: url)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(error as? RemoteImageError, .invalidImageData)
        }
    }

    func test_loadImage_onSuccess_cachesData() async throws {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        let imageData = UIImage(systemName: "star")!.pngData()!

        let requester = RequesterSpy()
        requester.result = .success(
            RequestSuccessResponse(
                data: imageData,
                response: HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
            )
        )

        let cache = ImageCacheSpy()
        let sut = RemoteImageLoader(
            requester: requester,
            cache: cache
        )

        // When
        _ = try await sut.loadImageData(from: url)

        // Then
        let cached = await cache.data(forKey: url.absoluteString)
        XCTAssertEqual(cached, imageData)
    }
}
// MARK: - Spies

private final class RequesterSpy: Requester {

    private(set) var callCount = 0
    var result: Result<RequestSuccessResponse, Error> =
        .failure(RequestError.invalidResponse)

    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        callCount += 1
        return try result.get()
    }
}

private actor ImageCacheSpy: ImageCaching {

    private var storage: [String: Data] = [:]

    func data(forKey key: String) -> Data? {
        storage[key]
    }

    func insert(_ data: Data?, forKey key: String) {
        storage[key] = data
    }

    func remove(forKey key: String) {
        storage[key] = nil
    }

    func removeAll() {
        storage.removeAll()
    }
}
