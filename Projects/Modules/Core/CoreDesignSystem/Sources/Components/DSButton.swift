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
            .fill(style == .primary ? DSColorToken.brand.color : DSColorToken.surface.color)
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: DSRadius.md.value)
            .stroke(DSColorToken.border.color, lineWidth: style == .secondary ? 1 : 0)
    }

    private var titleColorToken: DSColorToken {
        style == .primary ? .brandOn : .textPrimary
    }
}
