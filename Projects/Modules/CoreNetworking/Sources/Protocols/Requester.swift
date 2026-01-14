//
//  Requester.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

public protocol Requester {
    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse
}
