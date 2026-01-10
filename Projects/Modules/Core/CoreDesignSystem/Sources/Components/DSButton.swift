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
    private let title: String
    private let style: DSButtonStyle
    private let isLoading: Bool
    private let isEnabled: Bool
    private let action: @Sendable () -> Void

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

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: DSSpacing.xs.value) {
                if isLoading {
                    DSLoadingView()
                }
                DSText(title, style: .bodyEmphasis, color: titleColorToken)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.sm.value)
            .padding(.horizontal, DSSpacing.md.value)
        }
        .buttonStyle(.plain)
        .background(backgroundColor)
        .overlay(borderOverlay)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md.value))
        .opacity(isEnabled ? 1 : 0.5)
        .disabled(!isEnabled || isLoading)
    }

    private var backgroundColor: some View {
        RoundedRectangle(cornerRadius: DSRadius.md.value)
            .fill(
                style == .primary
                ? DSColorToken.brandPrimary.color
                : DSColorToken.brandSecondary.color
            )
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: DSRadius.md.value)
            .stroke(DSColorToken.border.color, lineWidth: style == .secondary ? 1 : 0)
    }

    private var titleColorToken: DSColorToken {
        style == .primary
        ? .brandPrimaryOn
        : .brandSecondaryOn
    }
}

private struct DSButtonPreviewScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg.value) {

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
            .padding(DSSpacing.lg.value)
            .background(DSColorToken.background.color)
        }
    }

    // MARK: - UI helpers

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm.value) {
            DSText(title, style: .title, color: .textPrimary)
            content()
        }
    }

    private func buttonRow(_ first: DSButton, _ second: DSButton, _ third: DSButton) -> some View {
        VStack(spacing: DSSpacing.sm.value) {
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
