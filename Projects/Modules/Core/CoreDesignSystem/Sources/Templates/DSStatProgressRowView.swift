//
//  DSStatProgressRowView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSStatProgressRowView: View {

    private let title: String
    private let valueText: String
    private let progress: CGFloat
    private let barColor: Color

    public init(
        title: String,
        valueText: String,
        progress: CGFloat,
        barColor: Color
    ) {
        self.title = title
        self.valueText = valueText
        self.progress = progress
        self.barColor = barColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header

            DSProgressView(
                progress: progress,
                size: .medium,
                trackColor: DSColorToken.surface.color.opacity(0.6),
                fillColor: barColor
            )
        }
        .padding(.vertical, 6)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            DSText(title, style: .body, color: .textSecondary)

            Spacer()

            DSText(valueText, style: .body, color: .textPrimary)
        }
    }
}

// MARK: - Convenience

public extension DSStatProgressRowView {
    init(
        title: String,
        value: Int,
        progress: CGFloat,
        barToken: DSColorToken
    ) {
        self.init(
            title: title,
            valueText: "\(value)",
            progress: progress,
            barColor: barToken.color
        )
    }
}
