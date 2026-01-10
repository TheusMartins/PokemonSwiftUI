//
//  DSPicker.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSPicker<Option: Hashable & Sendable>: View {
    private let title: String
    private let options: [Option]
    private let label: (Option) -> String
    @Binding private var selection: Option

    public init(
        title: String,
        options: [Option],
        selection: Binding<Option>,
        label: @escaping (Option) -> String
    ) {
        self.title = title
        self.options = options
        self._selection = selection
        self.label = label
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs.value) {
            DSText(title, style: .caption, color: .textSecondary)

            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(label(option)).tag(option)
                }
            }
            .pickerStyle(.menu)
            .padding(.vertical, DSSpacing.xs.value)
            .padding(.horizontal, DSSpacing.sm.value)
            .background(DSColorToken.surface.color)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(DSColorToken.border.color, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md.value))
        }
    }
}
