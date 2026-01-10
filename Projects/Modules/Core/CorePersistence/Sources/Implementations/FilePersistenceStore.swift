//
//  FilePersistenceStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// File-based persistence store.
///
/// Implementation details:
/// - Uses a base directory (Caches/Documents) and stores each key as a file.
/// - Uses a `FilePersisting` abstraction for testability.
/// - Actor-based API to showcase concurrency correctness.
public actor FilePersistenceStore: DataStore {
    private let directoryURL: URL
    private let filePersistor: FilePersisting

    public init(
        directory: PersistenceDirectory,
        filePersistor: FilePersisting = FileManagerFilePersistor(),
        fileManager: FileManager = .default
    ) async throws {
        self.filePersistor = filePersistor
        self.directoryURL = try directory.url(using: fileManager)
        try await filePersistor.createDirectoryIfNeeded(at: directoryURL)
    }

    public func save(_ data: Data, for key: PersistenceKey) async throws {
        let url = fileURL(for: key)
        try await filePersistor.write(data, to: url)
    }

    public func load(for key: PersistenceKey) async throws -> Data? {
        let url = fileURL(for: key)
        return try await filePersistor.contents(at: url)
    }

    public func remove(for key: PersistenceKey) async throws {
        let url = fileURL(for: key)
        try await filePersistor.removeItem(at: url)
    }

    public func removeAll() async throws {
        try await filePersistor.removeContentsOfDirectory(at: directoryURL)
    }

    // MARK: - Helpers

    private func fileURL(for key: PersistenceKey) -> URL {
        // Very simple sanitize to avoid weird filenames in a showcase project
        let safe = key.rawValue
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")

        return directoryURL.appendingPathComponent("\(safe).data", isDirectory: false)
    }
}
