//
//  FilePersistenceStore.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public final class FilePersistenceStore: PersistenceStore {

    private let directoryURL: URL
    private let fileManager: FileManager

    public init(
        directory: Directory,
        fileManager: FileManager = .default
    ) throws {
        self.fileManager = fileManager
        self.directoryURL = try directory.url(using: fileManager)
        try createDirectoryIfNeeded()
    }

    public func save(_ data: Data, for key: PersistableKey) throws {
        let url = fileURL(for: key)
        try data.write(to: url, options: .atomic)
    }

    public func load(for key: PersistableKey) throws -> Data? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        return try Data(contentsOf: url)
    }

    public func remove(for key: PersistableKey) throws {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    public func removeAll() throws {
        let contents = try fileManager.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: nil
        )

        for file in contents {
            try fileManager.removeItem(at: file)
        }
    }

    // MARK: - Helpers

    private func fileURL(for key: PersistableKey) -> URL {
        directoryURL.appendingPathComponent(key.rawValue)
    }

    private func createDirectoryIfNeeded() throws {
        guard !fileManager.fileExists(atPath: directoryURL.path) else { return }

        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
    }
}

public extension FilePersistenceStore {

    static func cacheStore(
        folderName: String
    ) throws -> FilePersistenceStore {
        let baseURL = try FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let folderURL = baseURL.appendingPathComponent(folderName)
        return try FilePersistenceStore(directory: .custom(folderURL))
    }
}
