//
//  FilePersisting.swift
//  CorePersistence
//
//  Created by Matheus Martins on 12/01/26.
//

import Foundation

public protocol FilePersisting: Sendable {
    func read(from url: URL) async throws -> Data?
    func write(_ data: Data, to url: URL) async throws
    func delete(at url: URL) async throws
    func createDirectoryIfNeeded(at url: URL) async throws
}
