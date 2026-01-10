//
//  DSText.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSText: View {
    private let text: String
    private let style: DSTextStyle
    private let color: DSColorToken

    public init(
        _ text: String,
        style: DSTextStyle = .body,
        color: DSColorToken = .textPrimary
    ) {
        self.text = text
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(style.typography.font)
            .foregroundStyle(color.color)
            .lineSpacing(style.typography.lineSpacing)
    }
}
