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

    /// Extra extra extra small spacing (2pt)
    case xxxs = 2

    /// Extra extra small spacing (4pt)
    case xxs = 4

    /// Extra small spacing (8pt)
    case xs = 8

    /// Small spacing (12pt)
    case sm = 12

    /// Medium spacing (16pt)
    case md = 16

    /// Large spacing (24pt)
    case lg = 24

    /// Extra large spacing (32pt)
    case xl = 32

    /// Extra extra large spacing (40pt)
    case xxl = 40

    /// Raw spacing value in points.
    public var value: CGFloat { rawValue }
}
