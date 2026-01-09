//
//  PersistenceError.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public enum PersistenceError: Error, Equatable, Sendable {
    case invalidDirectoryURL
    case failedToCreateDirectory
    case failedToWriteFile
    case failedToReadFile
    case failedToDeleteFile
    case failedToDeleteAllFiles
    case decodingFailed
    case encodingFailed
}
