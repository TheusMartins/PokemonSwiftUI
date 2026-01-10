//
//  DSRadius.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import Foundation

public enum DSRadius: CGFloat, CaseIterable, Sendable {
    case sm = 8
    case md = 12
    case lg = 16

    public var value: CGFloat { rawValue }
}
