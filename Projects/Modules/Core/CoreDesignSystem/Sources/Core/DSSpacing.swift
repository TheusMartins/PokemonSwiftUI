//
//  DSSpacing.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

/// Design System spacing tokens.
/// Values are expressed in points (pt).
public enum DSSpacing: CGFloat, CaseIterable, Sendable {

    /// Micro spacing (2pt)
    case micro = 2

    /// Tiny spacing (4pt)
    case tiny = 4

    /// Small spacing (8pt)
    case small = 8

    /// Medium spacing (12pt)
    case medium = 12

    /// Large spacing (16pt)
    case large = 16

    /// Extra large spacing (24pt)
    case xLarge = 24

    /// Huge spacing (32pt)
    case huge = 32

    /// Massive spacing (40pt)
    case massive = 40

    public var value: CGFloat { rawValue }
}
