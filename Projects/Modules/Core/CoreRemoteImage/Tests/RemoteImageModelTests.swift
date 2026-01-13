//
//  RemoteImageModelTests.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import XCTest
import SwiftUI
@testable import CoreRemoteImage

@MainActor
final class RemoteImageModelTests: XCTestCase {

    func test_load_withNilURL_keepsIdle() async {
        // Given
        let sut = RemoteImageModel(loader: ImageLoaderMock())

        // When
        await sut.load(url: nil)

        // Then
        XCTAssertEqual(sut.state, .idle)
    }

    func test_load_success_setsSuccessState() async {
        // Given
        let mock = ImageLoaderMock()
        mock.result = .success(Self.makeValidPNGData())

        let sut = RemoteImageModel(loader: mock)
        let url = URL(string: "https://example.com/img.png")!

        // When
        await sut.load(url: url)

        // Then
        await assertEventually {
            if case .success = sut.state {
                return true
            }
            return false
        }
    }

    func test_load_failure_setsFailureState() async {
        // Given
        let mock = ImageLoaderMock()
        mock.result = .failure(NSError(domain: "test", code: 0))

        let sut = RemoteImageModel(loader: mock)
        let url = URL(string: "https://example.com/img.png")!

        // When
        await sut.load(url: url)

        // Then
        await assertEventually {
            sut.state == .failure
        }
    }

    // MARK: - Helpers

    private static func makeValidPNGData() -> Data {
        // A real, decodable image payload (prevents false negatives).
        let uiImage = UIImage(systemName: "checkmark")!
        return uiImage.pngData()!
    }
}

// MARK: - Test doubles

private final class ImageLoaderMock: ImageLoading, @unchecked Sendable {

    var result: Result<Data, Error> = .failure(
        NSError(domain: "test", code: 0)
    )

    func loadImageData(from url: URL) async throws -> Data {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Async helpers

@MainActor
private func assertEventually(
    timeout: UInt64 = 300_000_000,  // 0.3s
    pollInterval: UInt64 = 10_000_000, // 10ms
    file: StaticString = #filePath,
    line: UInt = #line,
    _ condition: @escaping () -> Bool
) async {
    let start = DispatchTime.now().uptimeNanoseconds

    while DispatchTime.now().uptimeNanoseconds - start < timeout {
        if condition() { return }
        try? await Task.sleep(nanoseconds: pollInterval)
    }

    XCTFail("Condition not met within timeout.", file: file, line: line)
}
