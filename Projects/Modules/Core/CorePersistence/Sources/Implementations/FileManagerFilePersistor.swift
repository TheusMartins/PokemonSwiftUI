//
//  FileManagerFilePersistor.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Concrete filesystem implementation.
/// As an actor, it is safe to hold non-Sendable types like FileManager/URL internally.
public actor FileManagerFilePersistor: FilePersisting {
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public func contents(at url: URL) async throws -> Data? {
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    public func write(_ data: Data, to url: URL) async throws {
        try data.write(to: url, options: .atomic)
    }

    public func removeItem(at url: URL) async throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    public func createDirectoryIfNeeded(at url: URL) async throws {
        if !fileManager.fileExists(atPath: url.path) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    public func removeContentsOfDirectory(at url: URL) async throws {
        guard fileManager.fileExists(atPath: url.path) else { return }

        let contents = try fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil
        )

        for fileURL in contents {
            try await removeItem(at: fileURL)
        }
    }
}
