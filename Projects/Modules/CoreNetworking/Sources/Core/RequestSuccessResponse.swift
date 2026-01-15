//
//  RequestSuccessResponse.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

public struct RequestSuccessResponse {

    // MARK: - Properties

    public let data: Data
    public let response: URLResponse

    // MARK: - Init

    public init(
        data: Data,
        response: URLResponse
    ) {
        self.data = data
        self.response = response
    }
}
