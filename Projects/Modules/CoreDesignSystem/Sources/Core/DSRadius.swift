//
//  DSRadius.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

/// Design System corner radius tokens.
/// Values are expressed in points (pt).
public enum DSRadius: CGFloat, CaseIterable, Sendable {

    /// Small radius (8pt)
    case small = 8

    /// Medium radius (12pt)
    case medium = 12

    /// Large radius (16pt)
    case large = 16

    public var value: CGFloat { rawValue }
}
