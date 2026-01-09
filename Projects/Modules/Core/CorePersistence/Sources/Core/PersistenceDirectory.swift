//
//  PersistenceDirectory.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Defines where files should be stored.
///
/// - applicationSupport: User data that should survive app restarts and backups.
/// - caches: Re-creatable data (e.g. network cache). The system may purge it.
public enum PersistenceDirectory: Sendable {
    case applicationSupport
    case caches
}
