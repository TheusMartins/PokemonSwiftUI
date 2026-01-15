//
//  DefaultJSONCoder.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public struct DefaultJSONCoder: JSONCoding {

    // MARK: - Private Properties

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // MARK: - Initialization

    public init(
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }

    // MARK: - Public Methods

    /// Encodes a value into JSON data.
    /// - Throws: `PersistenceError.unableToEncode` when encoding fails.
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw PersistenceError.unableToEncode(error)
        }
    }

    /// Decodes JSON data into a strongly typed value.
    /// - Throws: `PersistenceError.unableToDecode` when decoding fails.
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw PersistenceError.unableToDecode(error)
        }
    }
}
