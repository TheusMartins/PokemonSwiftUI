//
//  DSPicker.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSPicker<Option: Hashable & Sendable>: View {
    private let title: String?
    private let options: [Option]
    private let label: @Sendable (Option) -> String
    @Binding private var selection: Option
    private let onSelectionChanged: (@MainActor @Sendable (Option) -> Void)?

    @State private var isPresented = false

    public init(
        title: String? = nil,
        options: [Option],
        selection: Binding<Option>,
        label: @escaping @Sendable (Option) -> String,
        onSelectionChanged: (@MainActor @Sendable (Option) -> Void)? = nil
    ) {
        self.title = title
        self.options = options
        self._selection = selection
        self.label = label
        self.onSelectionChanged = onSelectionChanged
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs.value) {
            if let title {
                DSText(title, style: .caption, color: .textSecondary)
            }

            Button {
                isPresented = true
            } label: {
                HStack(alignment: .center, spacing: DSSpacing.sm.value) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isPresented ? 180 : 0))
                        .animation(.easeInOut(duration: 0.18), value: isPresented)
                        .foregroundStyle(DSColorToken.textSecondary.color)
                    
                    DSText(label(selection), style: .title, color: .textPrimary)

                    
                    Spacer()

                }
                .padding(.vertical, DSSpacing.sm.value)
                .padding(.horizontal, DSSpacing.md.value)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(title ?? "Picker")
            .accessibilityValue(label(selection))
        }
        .sheet(isPresented: $isPresented) {
            OptionSheet(
                title: title,
                options: options,
                selection: $selection,
                label: { @Sendable option in
                    label(option)
                },
                onSelectionChanged: onSelectionChanged.map { handler in
                    { @MainActor @Sendable option in
                        handler(option)
                    }
                },
                dismiss: { isPresented = false }
            )
            .presentationDetents([.height(200), .medium, .large])
            .presentationDragIndicator(.hidden)
        }
    }
}

private struct OptionSheet<Option: Hashable & Sendable>: View {
    let title: String?
    let options: [Option]
    @Binding var selection: Option
    let label: @Sendable (Option) -> String
    let onSelectionChanged: (@MainActor @Sendable (Option) -> Void)?
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: DSSpacing.md.value) {
            if let title {
                DSText(title, style: .headline)
                    .padding(.top, DSSpacing.md.value)
            }

            List {
                ForEach(options, id: \.self) { option in
                    Button {
                        Task { @MainActor in
                            selection = option
                            onSelectionChanged?(option)
                            dismiss()
                        }
                    } label: {
                        HStack {
                            DSText(label(option), style: .body)

                            Spacer()

                            if option == selection {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(DSColorToken.pokemonBlue.color)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
        }
        .background(DSColorToken.background.color)
    }
}

private enum Generation: Int, CaseIterable, Hashable, Sendable {
    case gen1 = 1, gen2, gen3, gen4, gen5, gen6, gen7, gen8, gen9

    var title: String { "Generation \(rawValue)" }
}

private struct DSPickerPreviewContent: View {
    @State private var generation: Generation = .gen1

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg.value) {

            DSText("DSPicker Showcase", style: .headline)

            DSPicker(
                options: Generation.allCases,
                selection: $generation,
                label: { @Sendable in $0.title }
            )
            
            Spacer()

            DSText(
                "Selected: \(generation.title)",
                style: .caption,
                color: .textSecondary
            )
        }
    }
}

#Preview("DSPicker – Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.lg.value) {
            DSPickerPreviewContent()
        }
        .padding(DSSpacing.lg.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.light)
}

#Preview("DSPicker – Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.lg.value) {
            DSPickerPreviewContent()
        }
        .padding(DSSpacing.lg.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.dark)
}
