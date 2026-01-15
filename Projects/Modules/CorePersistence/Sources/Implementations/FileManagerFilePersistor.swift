//
//  FileManagerFilePersistor.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public actor FileManagerFilePersistor: FilePersisting {

    // MARK: - Private Properties

    private let fileManager: FileManager

    // MARK: - Initialization

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public Methods

    /// Reads data from the given file URL if it exists.
    public func read(from url: URL) async throws -> Data? {
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    /// Writes data to the given file URL using atomic write.
    public func write(_ data: Data, to url: URL) async throws {
        try data.write(to: url, options: .atomic)
    }

    /// Deletes the file at the given URL if it exists.
    public func delete(at url: URL) async throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    /// Creates the directory at the given URL if it does not exist.
    public func createDirectoryIfNeeded(at url: URL) async throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }
}
