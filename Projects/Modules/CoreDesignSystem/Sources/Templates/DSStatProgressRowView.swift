//
//  DSStatProgressRowView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSStatProgressRowView: View {

    // MARK: - Private properties

    private let title: String
    private let valueText: String
    private let progress: CGFloat
    private let barColor: Color

    // MARK: - Initialization

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

    // MARK: - View

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.small.value) {
            header

            DSProgressView(
                progress: progress,
                size: .medium,
                trackColor: DSColorToken.surface.color.opacity(0.6),
                fillColor: barColor
            )
        }
        .padding(.vertical, DSSpacing.small.value)
    }

    // MARK: - Private views

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

#Preview("DSStatProgressRowView – Light") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        VStack(spacing: DSSpacing.medium.value) {
            DSStatProgressRowView(
                title: "HP",
                value: 80,
                progress: 0.4,
                barToken: .pokemonYellow
            )

            DSStatProgressRowView(
                title: "Attack",
                value: 145,
                progress: 0.72,
                barToken: .pokemonTeal
            )

            DSStatProgressRowView(
                title: "Sp. Atk",
                value: 55,
                progress: 0.27,
                barToken: .danger
            )
        }
        .padding(DSSpacing.large.value)
    }
    .preferredColorScheme(.light)
}

#Preview("DSStatProgressRowView – Dark") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        VStack(spacing: DSSpacing.medium.value) {
            DSStatProgressRowView(
                title: "HP",
                value: 250,
                progress: 1.0,
                barToken: .pokemonTeal
            )

            DSStatProgressRowView(
                title: "Defense",
                value: 120,
                progress: 0.6,
                barToken: .brandSecondary
            )

            DSStatProgressRowView(
                title: "Speed",
                value: 30,
                progress: 0.15,
                barToken: .danger
            )
        }
        .padding(DSSpacing.large.value)
    }
    .preferredColorScheme(.dark)
}
