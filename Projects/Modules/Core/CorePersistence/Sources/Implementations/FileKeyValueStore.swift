//
//  FileKeyValueStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public actor FileKeyValueStore: KeyValueStoring {
    private let directoryURL: URL
    private let persistor: FilePersisting

    public init(
        directory: PersistenceDirectory,
        persistor: FilePersisting = FileManagerFilePersistor(),
        fileManager: FileManager = .default
    ) async throws {
        self.persistor = persistor
        self.directoryURL = try directory.url(using: fileManager)
        try await persistor.createDirectoryIfNeeded(at: directoryURL)
    }

    public func set(_ data: Data, for key: PersistenceKey) async throws {
        try await persistor.write(data, to: fileURL(for: key))
    }

    public func get(for key: PersistenceKey) async throws -> Data? {
        try await persistor.read(from: fileURL(for: key))
    }

    public func remove(for key: PersistenceKey) async throws {
        try await persistor.delete(at: fileURL(for: key))
    }

    public func removeAll() async throws {
        // Minimalista: remove a pasta inteira e recria.
        // (Funciona bem pro nosso caso e evita listar conteúdo.)
        try await persistor.delete(at: directoryURL)
        try await persistor.createDirectoryIfNeeded(at: directoryURL)
    }

    // MARK: - Helpers

    private func fileURL(for key: PersistenceKey) -> URL {
        let safeName = key.rawValue
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")

        return directoryURL.appendingPathComponent("\(safeName).data", isDirectory: false)
    }
}
