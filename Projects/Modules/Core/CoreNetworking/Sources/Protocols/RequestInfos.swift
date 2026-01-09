//
//  RequestInfos.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

public protocol RequestInfos {
    var baseURL: URL { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
}

public extension RequestInfos {
    var baseURL: URL { URL(string: "https://pokeapi.co/api/v2/")! }
    var parameters: [String: String]? { nil }
    var headers: [String: String]? { nil }
}
