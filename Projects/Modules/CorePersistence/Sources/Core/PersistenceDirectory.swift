//
//  PersistenceDirectory.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//


import Foundation

public enum PersistenceDirectory: Sendable {

    // MARK: - Cases

    case caches
    case documents

    // MARK: - Defaults

    /// Default directory choice for the app.
    public static let `default`: PersistenceDirectory = .caches

    // MARK: - Public API

    public func url(using fileManager: FileManager = .default) throws -> URL {
        let searchDirectory: FileManager.SearchPathDirectory

        switch self {
        case .caches:
            searchDirectory = .cachesDirectory
        case .documents:
            searchDirectory = .documentDirectory
        }

        guard let baseURL = fileManager.urls(
            for: searchDirectory,
            in: .userDomainMask
        ).first else {
            throw PersistenceError.unableToResolveDirectory
        }

        return baseURL.appendingPathComponent(
            "CorePersistence",
            isDirectory: true
        )
    }
}
