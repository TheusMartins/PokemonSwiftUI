//
//  DSSearchBar.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 14/01/26.
//

import SwiftUI

public struct DSSearchBar: View {
    @Binding private var text: String
    private let placeholder: String
    private let onSubmit: (@Sendable () -> Void)?

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        onSubmit: (@Sendable () -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: DSSpacing.medium.value) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(DSColorToken.textSecondary.color)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(DSColorToken.textSecondary.color)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, DSSpacing.large.value)
        .padding(.vertical, DSSpacing.medium.value)
        .background(DSColorToken.surface.color)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(DSColorToken.border.color, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search")
    }
}

struct DSSearchBar_Previews: PreviewProvider {

    private struct PreviewContainer: View {
        @State private var emptyText: String = ""
        @State private var filledText: String = "pikachu"

        var body: some View {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Empty")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    DSSearchBar(
                        text: $emptyText,
                        placeholder: "Search Pokémon"
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("With text")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    DSSearchBar(
                        text: $filledText,
                        placeholder: "Search Pokémon"
                    )
                }

                Spacer()
            }
            .padding()
            .background(DSColorToken.background.color)
        }
    }

    static var previews: some View {
        Group {
            PreviewContainer()
                .previewDisplayName("Light")
                .preferredColorScheme(.light)

            PreviewContainer()
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
