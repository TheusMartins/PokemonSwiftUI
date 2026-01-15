//
//  RequestInfos.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

// MARK: - RequestInfos

/// Describes everything needed to build a network request.
/// Acts as a lightweight request definition.
public protocol RequestInfos {

    // MARK: - Request components

    /// Base URL for the request.
    /// If `nil`, `endpoint` must contain the full URL.
    var baseURL: URL? { get }

    /// Endpoint path or full URL string.
    var endpoint: String { get }

    /// HTTP method used by the request.
    var method: HTTPMethod { get }

    /// Optional query or body parameters.
    var parameters: [String: String]? { get }

    /// Optional HTTP headers.
    var headers: [String: String]? { get }
}

// MARK: - Default values

public extension RequestInfos {

    /// Default base URL for the app (PokéAPI).
    var baseURL: URL? {
        URL(string: "https://pokeapi.co/api/v2/")
    }

    /// No parameters by default.
    var parameters: [String: String]? {
        nil
    }

    /// No headers by default.
    var headers: [String: String]? {
        nil
    }
}
