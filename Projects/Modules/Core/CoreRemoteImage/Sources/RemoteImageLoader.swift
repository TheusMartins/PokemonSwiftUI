import Foundation
import CoreNetworking

public protocol RemoteImageLoading {
    func data(for url: URL) async throws -> Data
}

public final class RemoteImageLoader: RemoteImageLoading {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func data(for url: URL) async throws -> Data {
        let response = try await client.get(url)
        return response.data
    }
}
