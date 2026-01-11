//
//  DSIconSize.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import Foundation

/// Design System icon size tokens.
/// Values are expressed in points (pt).
public enum DSIconSize: CGFloat, CaseIterable, Sendable {

    /// Micro icon (4pt)
    case micro = 4

    /// Tiny icon (8pt)
    case tiny = 8

    /// Small icon (16pt)
    case small = 16

    /// Medium icon (24pt)
    case medium = 24

    /// Large icon (32pt)
    case large = 32

    /// Extra large icon (48pt)
    case xLarge = 48

    /// Huge icon (64pt)
    case huge = 64

    /// Massive icon (96pt)
    case massive = 96

    /// Jumbo icon (120pt)
    case jumbo = 120

    public var value: CGFloat { rawValue }
}
