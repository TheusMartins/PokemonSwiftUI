//
//  DSSpacing.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

public enum DSSpacing: CGFloat, CaseIterable, Sendable {
    case xxxs = 2
    case xxs = 4
    case xs = 8
    case sm = 12
    case md = 16
    case lg = 24
    case xl = 32
    case xxl = 40

    public var value: CGFloat { rawValue }
}
