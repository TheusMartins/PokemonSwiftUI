//
//  JSONCoding.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Encodes/decodes values to/from Data.
/// Useful for keeping JSON encoding concerns out of the store implementation.
public protocol JSONCoding: Sendable {
    func encode<T: Encodable>(_ value: T) throws -> Data
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
