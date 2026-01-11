//
//  DSPillView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSPillView: View {
    public enum Size: Sendable {
        case sm
        case md
        case lg

        var horizontalPadding: CGFloat {
            switch self {
            case .sm: return 8
            case .md: return 10
            case .lg: return 12
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .sm: return 4
            case .md: return 6
            case .lg: return 8
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .sm: return 10
            case .md: return 12
            case .lg: return 14
            }
        }

        var font: Font {
            switch self {
            case .sm: return .caption
            case .md: return .callout
            case .lg: return .subheadline
            }
        }
    }

    private let text: String
    private let size: Size
    private let background: Color
    private let foreground: Color
    private let border: Color?
    private let borderWidth: CGFloat
    private let isUppercased: Bool

    public init(
        _ text: String,
        size: Size = .md,
        background: Color,
        foreground: Color = .white,
        border: Color? = nil,
        borderWidth: CGFloat = 1,
        isUppercased: Bool = false
    ) {
        self.text = text
        self.size = size
        self.background = background
        self.foreground = foreground
        self.border = border
        self.borderWidth = borderWidth
        self.isUppercased = isUppercased
    }

    public var body: some View {
        Text(isUppercased ? text.uppercased() : text)
            .font(size.font.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                Capsule()
                    .fill(background)
            )
            .overlay(
                Group {
                    if let border {
                        Capsule().stroke(border, lineWidth: borderWidth)
                    }
                }
            )
            .accessibilityLabel(text)
    }
}

// MARK: - DS convenience

public extension DSPillView {
    init(
        _ text: String,
        size: Size = .md,
        backgroundToken: DSColorToken,
        foregroundToken: DSColorToken = .brandPrimaryOn,
        borderToken: DSColorToken? = nil,
        borderWidth: CGFloat = 1,
        isUppercased: Bool = false
    ) {
        self.init(
            text,
            size: size,
            background: backgroundToken.color,
            foreground: foregroundToken.color,
            border: borderToken?.color,
            borderWidth: borderWidth,
            isUppercased: isUppercased
        )
    }
}
