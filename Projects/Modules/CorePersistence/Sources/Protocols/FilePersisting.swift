//
//  FilePersisting.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

/// Abstraction responsible for persisting raw data to the file system.
public protocol FilePersisting: Sendable {

    /// Reads data from the given file URL, returning nil if the file does not exist.
    func read(from url: URL) async throws -> Data?

    /// Writes data to the given file URL.
    func write(_ data: Data, to url: URL) async throws

    /// Deletes the file at the given URL if it exists.
    func delete(at url: URL) async throws

    /// Creates the directory at the given URL if it does not exist.
    func createDirectoryIfNeeded(at url: URL) async throws
}
