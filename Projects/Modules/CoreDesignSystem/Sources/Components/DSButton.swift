//
//  DSButton.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public enum DSButtonStyle: Sendable {
    case primary
    case secondary
}

public struct DSButton: View {

    // MARK: - Private properties

    private let title: String
    private let style: DSButtonStyle
    private let isLoading: Bool
    private let isEnabled: Bool
    private let action: @Sendable () -> Void

    // MARK: - Initialization

    public init(
        title: String,
        style: DSButtonStyle = .primary,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping @Sendable () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }

    // MARK: - View

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.small.value) {
                if isLoading {
                    DSLoadingView()
                }
                DSText(title, style: .bodyEmphasis, color: titleColorToken)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.medium.value)
            .padding(.horizontal, DSSpacing.large.value)
        }
        .buttonStyle(.plain)
        .background(background)
        .overlay(borderOverlay)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium.value))
        .opacity(isEnabled ? 1 : Constants.disabledOpacity)
        .disabled(!isEnabled || isLoading)
    }

    // MARK: - Tokens

    private var background: some View {
        RoundedRectangle(cornerRadius: DSRadius.medium.value)
            .fill(backgroundColor)
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: DSRadius.medium.value)
            .stroke(borderColor, lineWidth: borderLineWidth)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return DSColorToken.brandPrimary.color
        case .secondary:
            return DSColorToken.brandSecondary.color
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary:
            return .clear
        case .secondary:
            return DSColorToken.border.color
        }
    }

    private var borderLineWidth: CGFloat {
        switch style {
        case .primary:
            return 0
        case .secondary:
            return Constants.secondaryBorderLineWidth
        }
    }

    private var titleColorToken: DSColorToken {
        switch style {
        case .primary:
            return .brandPrimaryOn
        case .secondary:
            return .brandSecondaryOn
        }
    }
}

// MARK: - Constants

private extension DSButton {
    enum Constants {
        static let disabledOpacity: CGFloat = 0.5
        static let secondaryBorderLineWidth: CGFloat = 1
    }
}

// MARK: - Preview

private struct DSButtonPreviewScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xLarge.value) {

                section("Primary") {
                    buttonRow(
                        DSButton(title: "Primary", style: .primary) {},
                        DSButton(title: "Primary (Loading)", style: .primary, isLoading: true) {},
                        DSButton(title: "Primary (Disabled)", style: .primary, isEnabled: false) {}
                    )
                }

                section("Secondary") {
                    buttonRow(
                        DSButton(title: "Secondary", style: .secondary) {},
                        DSButton(title: "Secondary (Loading)", style: .secondary, isLoading: true) {},
                        DSButton(title: "Secondary (Disabled)", style: .secondary, isEnabled: false) {}
                    )
                }

                section("Edge cases") {
                    buttonRow(
                        DSButton(title: "Long title — Lorem ipsum dolor sit amet", style: .primary) {},
                        DSButton(title: "Long title — Lorem ipsum dolor sit amet", style: .secondary) {},
                        DSButton(title: "Tap me", style: .primary) {}
                    )
                }
            }
            .padding(DSSpacing.xLarge.value)
            .background(DSColorToken.background.color)
        }
    }

    // MARK: - UI helpers

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.medium.value) {
            DSText(title, style: .title, color: .textPrimary)
            content()
        }
    }

    private func buttonRow(_ first: DSButton, _ second: DSButton, _ third: DSButton) -> some View {
        VStack(spacing: DSSpacing.medium.value) {
            first
            second
            third
        }
    }
}

#Preview("DSButton - Dark") {
    DSButtonPreviewScreen()
        .preferredColorScheme(.dark)
}

#Preview("DSButton - Light") {
    DSButtonPreviewScreen()
        .preferredColorScheme(.light)
}
