//
//  DSPillView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSPillView: View {

    // MARK: - Nested types

    public enum Size: Sendable {
        case small
        case medium
        case large

        // MARK: - Tokens

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return DSSpacing.small.value
            case .medium: return DSSpacing.medium.value
            case .large: return DSSpacing.large.value
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return DSSpacing.small.value / 2
            case .medium: return DSSpacing.small.value * 0.75
            case .large: return DSSpacing.small.value
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return DSRadius.small.value
            case .medium: return DSRadius.medium.value
            case .large: return DSRadius.large.value
            }
        }

        var font: Font {
            switch self {
            case .small: return .caption
            case .medium: return .callout
            case .large: return .subheadline
            }
        }
    }

    // MARK: - Private properties

    private let text: String
    private let size: Size
    private let background: Color
    private let foreground: Color
    private let border: Color?
    private let borderWidth: CGFloat
    private let isUppercased: Bool

    // MARK: - Initialization

    public init(
        _ text: String,
        size: Size = .medium,
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

    // MARK: - View

    public var body: some View {
        Text(displayText)
            .font(size.font.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(backgroundView)
            .overlay(borderOverlay)
            .accessibilityLabel(text)
    }

    // MARK: - UI helpers

    private var displayText: String {
        isUppercased ? text.uppercased() : text
    }

    private var backgroundView: some View {
        Capsule()
            .fill(background)
    }

    private var borderOverlay: some View {
        Group {
            if let border {
                Capsule()
                    .stroke(border, lineWidth: borderWidth)
            }
        }
    }
}

// MARK: - DS convenience

public extension DSPillView {

    // MARK: - Initialization

    init(
        _ text: String,
        size: Size = .medium,
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

#Preview("DSPillView – Light") {
    VStack(alignment: .leading, spacing: DSSpacing.large.value) {

        DSText("Small", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Fire", size: .small, backgroundToken: .pokemonRed)
            DSPillView("Water", size: .small, backgroundToken: .pokemonBlue)
            DSPillView(
                "Electric",
                size: .small,
                backgroundToken: .pokemonYellow,
                foregroundToken: .textPrimary
            )
        }

        DSText("Medium", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Default", size: .medium, backgroundToken: .brandSecondary)
            DSPillView(
                "Bordered",
                size: .medium,
                backgroundToken: .surface,
                foregroundToken: .textPrimary,
                borderToken: .border
            )
            DSPillView(
                "UPPER",
                size: .medium,
                backgroundToken: .brandPrimary,
                isUppercased: true
            )
        }

        DSText("Large", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Grass", size: .large, backgroundToken: .brandPrimary)
            DSPillView(
                "Surface",
                size: .large,
                backgroundToken: .surface,
                foregroundToken: .textPrimary,
                borderToken: .border
            )
        }
    }
    .padding(DSSpacing.xLarge.value)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(DSColorToken.background.color)
    .preferredColorScheme(.light)
}

#Preview("DSPillView – Dark") {
    VStack(alignment: .leading, spacing: DSSpacing.large.value) {

        DSText("Small", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Fire", size: .small, backgroundToken: .pokemonRed)
            DSPillView("Water", size: .small, backgroundToken: .pokemonBlue)
            DSPillView(
                "Electric",
                size: .small,
                backgroundToken: .pokemonYellow,
                foregroundToken: .textPrimary
            )
        }

        DSText("Medium", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Default", size: .medium, backgroundToken: .brandSecondary)
            DSPillView(
                "Bordered",
                size: .medium,
                backgroundToken: .surface,
                foregroundToken: .textPrimary,
                borderToken: .border
            )
            DSPillView(
                "UPPER",
                size: .medium,
                backgroundToken: .brandPrimary,
                isUppercased: true
            )
        }

        DSText("Large", style: .title, color: .textSecondary)
        HStack(spacing: DSSpacing.small.value) {
            DSPillView("Grass", size: .large, backgroundToken: .brandPrimary)
            DSPillView(
                "Surface",
                size: .large,
                backgroundToken: .surface,
                foregroundToken: .textPrimary,
                borderToken: .border
            )
        }
    }
    .padding(DSSpacing.xLarge.value)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(DSColorToken.background.color)
    .preferredColorScheme(.dark)
}
