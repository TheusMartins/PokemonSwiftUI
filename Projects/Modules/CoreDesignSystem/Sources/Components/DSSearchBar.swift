//
//  DSSearchBar.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 14/01/26.
//

import SwiftUI

public struct DSSearchBar: View {

    // MARK: - Bindings

    @Binding private var text: String

    // MARK: - Private properties

    private let placeholder: String
    private let onSubmit: (@Sendable () -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        onSubmit: (@Sendable () -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    // MARK: - View

    public var body: some View {
        HStack(spacing: DSSpacing.medium.value) {
            Image(systemName: iconName)
                .foregroundStyle(DSColorToken.textSecondary.color)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }

            if shouldShowClearButton {
                Button(action: clearText) {
                    Image(systemName: clearIconName)
                        .foregroundStyle(DSColorToken.textSecondary.color)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(accessibilityClearLabel)
            }
        }
        .padding(.horizontal, DSSpacing.large.value)
        .padding(.vertical, DSSpacing.medium.value)
        .background(DSColorToken.surface.color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(borderOverlay)
        .contentShape(Rectangle())
        .onTapGesture(perform: focus)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilitySearchLabel)
    }

    // MARK: - UI tokens

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(DSColorToken.border.color, lineWidth: 1)
    }

    private var cornerRadius: CGFloat { 12 }

    // MARK: - Computed

    private var shouldShowClearButton: Bool {
        !text.isEmpty
    }

    // MARK: - Actions

    private func clearText() {
        text = ""
    }

    private func focus() {
        isFocused = true
    }
}

// MARK: - Constants

private extension DSSearchBar {
    var iconName: String { "magnifyingglass" }
    var clearIconName: String { "xmark.circle.fill" }

    var accessibilitySearchLabel: String { "Search" }
    var accessibilityClearLabel: String { "Clear search" }
}

// MARK: - Preview

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
