//
//  RequesterSpy.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
import CoreNetworking

final class RequesterSpy: Requester {

    private(set) var requestCalls: [RequestInfos] = []
    var stubbedResult: Result<RequestSuccessResponse, Error>?

    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        requestCalls.append(infos)

        guard let stubbedResult else {
            XCTFail("You must set stubbedResult before calling request(_:).")
            throw DummyError.missingStub
        }

        switch stubbedResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Errors

enum DummyError: Error {
    case any
    case missingStub
}
