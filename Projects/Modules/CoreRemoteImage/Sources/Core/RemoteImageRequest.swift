//
//  RemoteImageRequest.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import CoreNetworking

public struct RemoteImageRequest: RequestInfos {

    // MARK: - Public Properties

    public let url: URL

    // MARK: - Initialization

    public init(url: URL) {
        self.url = url
    }

    // MARK: - RequestInfos

    public var baseURL: URL? { nil }

    public var endpoint: String { url.absoluteString }

    public var method: HTTPMethod { .get }

    public var parameters: [String: Any]? { nil }
}
