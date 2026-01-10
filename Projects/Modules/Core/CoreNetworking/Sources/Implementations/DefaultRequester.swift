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
        let urlString: String

        if let baseURL = infos.baseURL {
            urlString = "\(baseURL)\(infos.endpoint)"
        } else {
            urlString = infos.endpoint
        }

        guard var url = URLComponents(string: urlString) else {
            return nil
        }

        infos.parameters?.forEach { key, value in
            url.queryItems = (url.queryItems ?? []) + [URLQueryItem(name: key, value: "\(value)")]
        }

        guard let finalURL = url.url else {
            return nil
        }

        return URLRequest(url: finalURL)
    }
}
