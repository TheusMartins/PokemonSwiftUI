//
//  DSText.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSText: View {

    // MARK: - Private properties

    private let text: String
    private let style: DSTextStyle
    private let color: DSColorToken

    // MARK: - Initialization

    public init(
        _ text: String,
        style: DSTextStyle = .body,
        color: DSColorToken = .textPrimary
    ) {
        self.text = text
        self.style = style
        self.color = color
    }

    // MARK: - View

    public var body: some View {
        Text(text)
            .font(style.typography.font)
            .foregroundStyle(color.color)
            .lineSpacing(style.typography.lineSpacing)
    }
}

// MARK: - Preview

#Preview("DSText – Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.large.value) {
            ForEach(DSTextStyle.allCases, id: \.self) { style in
                VStack(alignment: .leading, spacing: DSSpacing.small.value) {
                    DSText("\(style)", style: .title, color: .textSecondary)

                    DSText(
                        "The quick brown fox jumps over the lazy Pikachu",
                        style: style
                    )
                }
            }
        }
        .padding(DSSpacing.xLarge.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.light)
}

#Preview("DSText – Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.large.value) {
            ForEach(DSTextStyle.allCases, id: \.self) { style in
                VStack(alignment: .leading, spacing: DSSpacing.small.value) {
                    DSText("\(style)", style: .title, color: .textSecondary)

                    DSText(
                        "The quick brown fox jumps over the lazy Pikachu",
                        style: style
                    )
                }
            }
        }
        .padding(DSSpacing.xLarge.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.dark)
}
