//
//  CachePolicy.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Optional cache policy that can be used by stores that support expiration.
/// This keeps the decision at the call site and the logic testable.
public enum CachePolicy: Sendable, Equatable {
    case none
    case expiresIn(TimeInterval)
}
