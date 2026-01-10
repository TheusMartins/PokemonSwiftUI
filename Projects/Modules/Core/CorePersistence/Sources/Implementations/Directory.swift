//
//  Directory.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public enum Directory: Sendable {
    case caches
    case applicationSupport
    case documents
    case temporary

    public func url(using fileManager: FileManager = .default) throws -> URL {
        switch self {
        case .caches:
            return try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        case .applicationSupport:
            let url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return url

        case .documents:
            return try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        case .temporary:
            return fileManager.temporaryDirectory
        }
    }
}
