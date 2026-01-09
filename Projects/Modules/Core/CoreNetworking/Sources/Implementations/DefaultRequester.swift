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
        var components = URLComponents(
            url: infos.baseURL.appendingPathComponent(infos.endpoint),
            resolvingAgainstBaseURL: false
        )

        if let parameters = infos.parameters, !parameters.isEmpty {
            components?.queryItems = parameters
                .map { URLQueryItem(name: $0.key, value: $0.value) }
                .sorted { $0.name < $1.name }
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = infos.method.rawValue

        infos.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
