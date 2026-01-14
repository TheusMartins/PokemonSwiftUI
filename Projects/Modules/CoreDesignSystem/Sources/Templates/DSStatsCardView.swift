//
//  DSStatsCardView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSStatsCardView: View {

    private let title: String
    private let rows: [Row]

    public struct Row: Identifiable, Equatable {
        public let id: String
        public let title: String
        public let value: Int
        public let progress: CGFloat
        public let barToken: DSColorToken

        public init(
            id: String,
            title: String,
            value: Int,
            progress: CGFloat,
            barToken: DSColorToken
        ) {
            self.id = id
            self.title = title
            self.value = value
            self.progress = progress
            self.barToken = barToken
        }
    }

    public init(
        title: String,
        rows: [Row]
    ) {
        self.title = title
        self.rows = rows
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.medium.value) {
            DSText(title, style: .title)

            VStack {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    DSStatProgressRowView(title: row.title, value: row.value, progress: row.progress, barToken: row.barToken)
                }
            }
            .padding(DSSpacing.large.value)
            .background(DSColorToken.surface.color)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous))
        }
    }
}

#Preview("DSStatsCardView – Light") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        DSStatsCardView(
            title: "Base stats",
            rows: [
                .init(id: "hp", title: "HP", value: 80, progress: 0.40, barToken: .pokemonYellow),
                .init(id: "attack", title: "Attack", value: 125, progress: 0.63, barToken: .brandSecondary),
                .init(id: "defense", title: "Defense", value: 100, progress: 0.50, barToken: .pokemonYellow),
                .init(id: "sp_atk", title: "Sp. Atk", value: 55, progress: 0.28, barToken: .danger),
                .init(id: "sp_def", title: "Sp. Def", value: 75, progress: 0.38, barToken: .pokemonYellow),
                .init(id: "speed", title: "Speed", value: 145, progress: 0.73, barToken: .pokemonTeal)
            ]
        )
        .padding(DSSpacing.xLarge.value)
    }
    .preferredColorScheme(.light)
}

#Preview("DSStatsCardView – Dark") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        DSStatsCardView(
            title: "Base stats",
            rows: [
                .init(id: "hp", title: "HP", value: 250, progress: 1.0, barToken: .pokemonTeal),
                .init(id: "attack", title: "Attack", value: 10, progress: 0.05, barToken: .danger),
                .init(id: "defense", title: "Defense", value: 180, progress: 0.90, barToken: .pokemonTeal),
                .init(id: "sp_atk", title: "Sp. Atk", value: 95, progress: 0.48, barToken: .pokemonYellow),
                .init(id: "sp_def", title: "Sp. Def", value: 120, progress: 0.60, barToken: .brandSecondary),
                .init(id: "speed", title: "Speed", value: 110, progress: 0.55, barToken: .brandSecondary)
            ]
        )
        .padding(DSSpacing.xLarge.value)
    }
    .preferredColorScheme(.dark)
}
