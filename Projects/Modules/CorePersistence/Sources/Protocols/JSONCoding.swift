//
//  JSONCoding.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

/// Encodes and decodes values using JSON.
public protocol JSONCoding: Sendable {

    /// Encodes a value into JSON data.
    func encode<T: Encodable>(_ value: T) throws -> Data

    /// Decodes a value of the given type from JSON data.
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
