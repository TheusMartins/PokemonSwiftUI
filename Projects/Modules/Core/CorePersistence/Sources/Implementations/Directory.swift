//
//  Directory.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public enum Directory {
    case documents
    case caches
    case custom(URL)

    func url(using fileManager: FileManager) throws -> URL {
        switch self {
        case .documents:
            return try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

        case .caches:
            return try fileManager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

        case .custom(let url):
            return url
        }
    }
}
