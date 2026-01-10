//
//  PersistenceDirectory.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public enum PersistenceDirectory: Sendable {
    case caches
    case documents

    public func url(using fileManager: FileManager = .default) throws -> URL {
        let search: FileManager.SearchPathDirectory
        switch self {
        case .caches: search = .cachesDirectory
        case .documents: search = .documentDirectory
        }

        guard let baseURL = fileManager.urls(for: search, in: .userDomainMask).first else {
            throw PersistenceError.unableToResolveDirectory
        }

        return baseURL.appendingPathComponent("CorePersistence", isDirectory: true)
    }
}
