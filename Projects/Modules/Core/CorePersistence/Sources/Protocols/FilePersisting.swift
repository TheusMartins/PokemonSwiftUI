//
//  FilePersisting.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Filesystem API boundary used by the persistence implementation.
///
/// This makes file-based storage easy to test (you can swap the implementation
/// by using a spy/mock without touching `FileManager` directly).
public protocol FilePersisting: Sendable {
    func contents(at url: URL) throws -> Data?
    func write(_ data: Data, to url: URL) throws
    func removeItem(at url: URL) throws
    func createDirectoryIfNeeded(at url: URL) throws
    func removeContentsOfDirectory(at url: URL) throws
}
