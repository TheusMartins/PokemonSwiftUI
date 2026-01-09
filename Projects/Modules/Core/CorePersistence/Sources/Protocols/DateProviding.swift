//
//  DateProviding.swift
//  CorePersistence
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

/// Provides the current date.
/// This is handy for making TTL / cleanup logic testable.
public protocol DateProviding: Sendable {
    var now: Date { get }
}
