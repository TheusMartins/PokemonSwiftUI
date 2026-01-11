//
//  DSTextStyle.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public enum DSTextStyle: Sendable, CaseIterable {
    case largeTitle
    case title
    case headline
    case body
    case bodyEmphasis
    case caption
}

public struct DSTypography: Sendable {
    public let font: Font
    public let lineSpacing: CGFloat

    public init(font: Font, lineSpacing: CGFloat = .zero) {
        self.font = font
        self.lineSpacing = lineSpacing
    }
}

public extension DSTextStyle {
    var typography: DSTypography {
        switch self {
        case .largeTitle:
            return .init(font: .system(size: 34, weight: .bold), lineSpacing: 2)
        case .title:
            return .init(font: .system(size: 24, weight: .semibold), lineSpacing: 1)
        case .headline:
            return .init(font: .system(size: 18, weight: .semibold), lineSpacing: 1)
        case .body:
            return .init(font: .system(size: 16, weight: .regular), lineSpacing: 0.5)
        case .bodyEmphasis:
            return .init(font: .system(size: 16, weight: .semibold), lineSpacing: 0.5)
        case .caption:
            return .init(font: .system(size: 13, weight: .regular), lineSpacing: 0.25)
        }
    }
}
