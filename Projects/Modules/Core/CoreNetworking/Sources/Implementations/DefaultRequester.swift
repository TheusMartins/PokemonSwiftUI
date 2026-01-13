//
//  DefaultRequester.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

public actor DefaultRequester: Requester {
    private let session: URLSession
    private var requestCount: Int = 0

    public init(session: URLSession = .shared) {
        self.session = session
    }

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
        return requestCount
    }

    // MARK: - Helpers


    private func buildURLRequest(basedOn infos: RequestInfos) -> URLRequest? {
        // 1) Resolve the base URL + endpoint into a valid absolute URL
        let components: URLComponents?

        if let baseURL = infos.baseURL {
            // Normalize endpoint to avoid double slashes or missing slash
            let trimmedEndpoint = infos.endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmedEndpoint.isEmpty else { return nil }

            let absolute = baseURL.appendingPathComponent(trimmedEndpoint).absoluteString
            components = URLComponents(string: absolute)
        } else {
            // Without a baseURL, we only accept an absolute endpoint (e.g. "https://...")
            components = URLComponents(string: infos.endpoint)

            // Reject relative URLs like "invalid" or "/path"
            guard
                let scheme = components?.scheme, !scheme.isEmpty,
                let host = components?.host, !host.isEmpty
            else {
                return nil
            }
        }

        guard var urlComponents = components else { return nil }

        // 2) Add query items
        if let parameters = infos.parameters, !parameters.isEmpty {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        // 3) Final URL must be absolute
        guard let finalURL = urlComponents.url, finalURL.scheme != nil else {
            return nil
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = infos.method.rawValue
        return request
    }
}
