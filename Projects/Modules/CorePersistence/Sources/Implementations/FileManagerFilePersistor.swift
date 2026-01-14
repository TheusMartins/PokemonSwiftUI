//
//  FileManagerFilePersistor.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public actor FileManagerFilePersistor: FilePersisting {
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public func read(from url: URL) async throws -> Data? {
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    public func write(_ data: Data, to url: URL) async throws {
        try data.write(to: url, options: .atomic)
    }

    public func delete(at url: URL) async throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    public func createDirectoryIfNeeded(at url: URL) async throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }
}
