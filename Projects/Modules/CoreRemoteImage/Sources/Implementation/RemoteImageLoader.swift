//
//  RemoteImageLoader.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import UIKit
import CoreNetworking

public enum RemoteImageError: Error, Equatable {

    // MARK: - Cases

    case invalidStatusCode(Int)
    case invalidImageData
}

public actor RemoteImageLoader: ImageLoading {

    // MARK: - Private Properties

    private let requester: Requester
    private let cache: ImageCaching

    // MARK: - Initialization

    public init(
        requester: Requester = DefaultRequester(),
        cache: ImageCaching = InMemoryImageCache()
    ) {
        self.requester = requester
        self.cache = cache
    }

    // MARK: - Public Methods

    public func loadImageData(from url: URL) async throws -> Data {
        let key = url.absoluteString

        if let cached = await cache.data(forKey: key) {
            return cached
        }

        let response = try await requester.request(
            basedOn: RemoteImageRequest(url: url)
        )

        if let http = response.response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw RemoteImageError.invalidStatusCode(http.statusCode)
        }

        guard UIImage(data: response.data) != nil else {
            throw RemoteImageError.invalidImageData
        }

        await cache.insert(response.data, forKey: key)
        return response.data
    }
}
