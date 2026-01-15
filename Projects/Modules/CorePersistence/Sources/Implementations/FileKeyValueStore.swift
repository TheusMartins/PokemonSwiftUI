//
//  FileKeyValueStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public actor FileKeyValueStore: KeyValueStoring {

    // MARK: - Private Properties

    private let directoryURL: URL
    private let persistor: FilePersisting

    // MARK: - Initialization

    /// Default initializer for the app.
    /// Uses `.default` directory and the default `FilePersisting` implementation.
    public init() async throws {
        try await self.init(directory: .default)
    }

    /// Creates a file-backed key-value store under the provided persistence directory.
    public init(
        directory: PersistenceDirectory,
        persistor: FilePersisting = FileManagerFilePersistor(),
        fileManager: FileManager = .default
    ) async throws {
        self.persistor = persistor
        self.directoryURL = try directory.url(using: fileManager)
        try await persistor.createDirectoryIfNeeded(at: directoryURL)
    }

    // MARK: - Public Methods

    /// Persists the given data for the provided key.
    public func set(_ data: Data, for key: PersistenceKey) async throws {
        try await persistor.write(data, to: fileURL(for: key))
    }

    /// Reads the persisted data for the provided key.
    /// - Returns: The data if the file exists, otherwise `nil`.
    public func get(for key: PersistenceKey) async throws -> Data? {
        try await persistor.read(from: fileURL(for: key))
    }

    /// Deletes the persisted value for the provided key.
    public func remove(for key: PersistenceKey) async throws {
        try await persistor.delete(at: fileURL(for: key))
    }

    /// Deletes all persisted values by removing the whole directory and recreating it.
    public func removeAll() async throws {
        try await persistor.delete(at: directoryURL)
        try await persistor.createDirectoryIfNeeded(at: directoryURL)
    }

    // MARK: - Private Methods

    private func fileURL(for key: PersistenceKey) -> URL {
        let safeName = key.rawValue
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")

        return directoryURL.appendingPathComponent("\(safeName).data", isDirectory: false)
    }
}
