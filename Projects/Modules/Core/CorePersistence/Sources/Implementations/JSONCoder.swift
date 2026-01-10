//
//  JSONCoder.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public struct JSONCoder: JSONCoding {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }

    public func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw PersistenceError.unableToResolveDirectory
        }
    }

    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw PersistenceError.unableToEncode(error)
        }
    }
}
