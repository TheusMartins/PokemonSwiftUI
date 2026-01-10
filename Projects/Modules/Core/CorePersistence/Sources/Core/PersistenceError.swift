//
//  PersistenceError.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public enum PersistenceError: Error, Sendable {
    case unableToResolveDirectory
    case unableToEncode(Error)
}
