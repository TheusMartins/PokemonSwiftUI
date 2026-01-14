//
//  DSFeedbackView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI

public enum DSFeedbackStyle: Sendable {
    case success
    case warning
    case error
    case info
}

public struct DSFeedbackView: View {

    private let title: String
    private let message: String?
    private let style: DSFeedbackStyle

    public init(
        title: String,
        message: String? = nil,
        style: DSFeedbackStyle = .info
    ) {
        self.title = title
        self.message = message
        self.style = style
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.medium.value) {

            Image(systemName: iconName)
                .imageScale(.medium)
                .foregroundStyle(iconColor)

            VStack(alignment: .leading, spacing: DSSpacing.small.value) {
                DSText(title, style: .bodyEmphasis, color: titleColor)

                if let message, !message.isEmpty {
                    DSText(message, style: .body, color: messageColor)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, DSSpacing.medium.value)
        .padding(.horizontal, DSSpacing.large.value)
        .background(background)
        .overlay(borderOverlay)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    // MARK: - Tokens

    private var background: some View {
        RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous)
            .fill(backgroundColor)
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous)
            .stroke(borderColor, lineWidth: 1)
    }

    private var backgroundColor: Color {
        switch style {
        case .success:
            return DSColorToken.pokemonGreen.color.opacity(0.18)
        case .warning:
            return DSColorToken.pokemonYellow.color.opacity(0.18)
        case .error:
            return DSColorToken.danger.color.opacity(0.18)
        case .info:
            return DSColorToken.surface.color
        }
    }

    private var borderColor: Color {
        switch style {
        case .success:
            return DSColorToken.pokemonGreen.color.opacity(0.35)
        case .warning:
            return DSColorToken.pokemonYellow.color.opacity(0.35)
        case .error:
            return DSColorToken.danger.color.opacity(0.35)
        case .info:
            return DSColorToken.border.color.opacity(0.6)
        }
    }

    private var iconColor: Color {
        switch style {
        case .success:
            return DSColorToken.pokemonGreen.color
        case .warning:
            return DSColorToken.pokemonYellow.color
        case .error:
            return DSColorToken.danger.color
        case .info:
            return DSColorToken.textSecondary.color
        }
    }

    private var titleColor: DSColorToken {
        .textPrimary
    }

    private var messageColor: DSColorToken {
        .textSecondary
    }

    private var iconName: String {
        switch style {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        case .info: return "info.circle.fill"
        }
    }

    private var accessibilityText: String {
        if let message, !message.isEmpty {
            return "\(title). \(message)"
        }
        return title
    }
}

// MARK: - Preview

private struct DSFeedbackPreviewScreen: View {
    var body: some View {
        VStack(spacing: DSSpacing.large.value) {
            DSFeedbackView(
                title: "Pokémon added",
                message: "Scizor was added to your team.",
                style: .success
            )

            DSFeedbackView(
                title: "Pokémon removed",
                message: "Scizor was removed from your team.",
                style: .warning
            )

            DSFeedbackView(
                title: "Something went wrong",
                message: "Please try again.",
                style: .error
            )

            DSFeedbackView(
                title: "Heads up",
                message: "This is an informational message.",
                style: .info
            )
        }
        .padding(DSSpacing.xLarge.value)
        .background(DSColorToken.background.color)
    }
}

#Preview("DSFeedbackView - Light") {
    DSFeedbackPreviewScreen()
        .preferredColorScheme(.light)
}

#Preview("DSFeedbackView - Dark") {
    DSFeedbackPreviewScreen()
        .preferredColorScheme(.dark)
}
