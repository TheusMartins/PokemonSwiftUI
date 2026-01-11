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
        VStack(alignment: .leading, spacing: DSSpacing.sm.value) {
            DSText(title, style: .title)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    DSStatProgressRowView(title: row.title, value: row.value, progress: row.progress, barToken: row.barToken)

                    if index < rows.count - 1 {
                        Divider()
                            .overlay(DSColorToken.border.color.opacity(0.5))
                    }
                }
            }
            .padding(DSSpacing.md.value)
            .background(DSColorToken.surface.color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}
