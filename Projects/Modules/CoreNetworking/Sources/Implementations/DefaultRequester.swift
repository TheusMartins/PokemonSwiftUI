//
//  DefaultRequester.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

// MARK: - DefaultRequester

/// Default network requester used by the app.
/// Builds a `URLRequest` from `RequestInfos` and performs it using `URLSession`.
public actor DefaultRequester: Requester {

    // MARK: - Properties

    private let session: URLSession
    private var requestCount: Int = 0

    // MARK: - Initialization

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public API

    public func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        requestCount += 1

        guard let request = buildURLRequest(basedOn: infos) else {
            throw RequestError.invalidURL
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }

            guard (200...299).contains(http.statusCode) else {
                throw RequestError.invalidStatusCode(http.statusCode)
            }

            return .init(data: data, response: response)
        } catch let error as RequestError {
            throw error
        } catch {
            throw RequestError.transportError
        }
    }

    public func totalRequests() -> Int {
        requestCount
    }

    // MARK: - Helpers

    private func buildURLRequest(basedOn infos: RequestInfos) -> URLRequest? {
        guard let url = resolveURL(from: infos) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = infos.method.rawValue

        if let headers = infos.headers, !headers.isEmpty {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }

    private func resolveURL(from infos: RequestInfos) -> URL? {
        let components: URLComponents?

        if let baseURL = infos.baseURL {
            let trimmedEndpoint = infos.endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmedEndpoint.isEmpty else { return nil }

            let absolute = baseURL.appendingPathComponent(trimmedEndpoint).absoluteString
            components = URLComponents(string: absolute)
        } else {
            components = URLComponents(string: infos.endpoint)

            // Reject relative URLs like "invalid" or "/path".
            guard
                let scheme = components?.scheme, !scheme.isEmpty,
                let host = components?.host, !host.isEmpty
            else {
                return nil
            }
        }

        guard var urlComponents = components else { return nil }

        if let parameters = infos.parameters, !parameters.isEmpty {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        return urlComponents.url
    }
}
