//
//  FilePersisting.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

import Foundation

/// Filesystem API boundary used by the persistence implementation.
/// Actor-friendly: all operations are async.
public protocol FilePersisting: Sendable {
    func contents(at url: URL) async throws -> Data?
    func write(_ data: Data, to url: URL) async throws
    func removeItem(at url: URL) async throws
    func createDirectoryIfNeeded(at url: URL) async throws
    func removeContentsOfDirectory(at url: URL) async throws
}
