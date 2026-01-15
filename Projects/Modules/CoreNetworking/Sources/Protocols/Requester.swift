//
//  Requester.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

// MARK: - Requester

/// Abstraction responsible for executing network requests
/// based on a `RequestInfos` definition.
public protocol Requester: Sendable {

    // MARK: - Request

    func request(
        basedOn infos: RequestInfos
    ) async throws -> RequestSuccessResponse
}
