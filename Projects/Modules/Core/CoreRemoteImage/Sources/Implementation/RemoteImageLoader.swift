//
//  RemoteImageLoader.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import SwiftUI
import UIKit
import CoreNetworking

public enum RemoteImageError: Error, Equatable {
    case invalidStatusCode(Int)
    case invalidImageData
}

public actor RemoteImageLoader: ImageLoading {
    private let requester: Requester
    private let cache: ImageCaching

    public init(
        requester: Requester,
        cache: ImageCaching = InMemoryImageCache()
    ) {
        self.requester = requester
        self.cache = cache
    }

    public func loadImage(from url: URL) async throws -> Image {
        let key = url.absoluteString

        if let cached = await cache.image(forKey: key) {
            return cached
        }

        let response = try await requester.request(basedOn: RemoteImageRequest(url: url))

        if let http = response.response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw RemoteImageError.invalidStatusCode(http.statusCode)
        }

        guard let uiImage = UIImage(data: response.data) else {
            throw RemoteImageError.invalidImageData
        }

        let image = Image(uiImage: uiImage)
        await cache.insert(image, forKey: key)
        return image
    }
}
