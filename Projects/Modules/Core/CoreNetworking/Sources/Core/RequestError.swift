//
//  RequestError.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

public enum RequestError: Error, Equatable {
    case invalidURL
    case transportError
    case invalidResponse
    case invalidStatusCode(Int)
}
