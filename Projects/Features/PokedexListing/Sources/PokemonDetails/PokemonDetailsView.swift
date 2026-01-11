//
//  PokemonDetailsView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI
import CoreDesignSystem
import CoreRemoteImage

struct PokemonDetailsView: View {
    @StateObject private var viewModel: PokemonDetailsViewModel

    init(pokemonName: String) {
        _viewModel = StateObject(wrappedValue: PokemonDetailsViewModel(pokemonName: pokemonName))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                EmptyView()

            case .loading:
                DSLoadingView(size: 60)

            case .loaded:
                makeContent()

            case .failed:
                makeError()
            }
        }
        .background(DSColorToken.background.color)
        .navigationTitle(viewModel.model?.name.capitalized ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    // MARK: - Content

    private func makeContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                makeSpritesRow()
                makeTypesRow()
                makeStatsSection()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }

    private func makeSpritesRow() -> some View {
        let frontDefault = viewModel.model?.sprites.frontDefault
        let frontShiny = viewModel.model?.sprites.frontShiny

        return HStack(spacing: 12) {
            makeSpriteCard(title: "Default", url: frontDefault)
            makeSpriteCard(title: "Shiny", url: frontShiny)
        }
    }

    private func makeSpriteCard(title: String, url: URL?) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(DSColorToken.textPrimary.color)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(DSColorToken.surface.color)

                Group {
                    if let url {
                        RemoteImageView(
                            url: url,
                            placeholder: { Color.clear },
                            loading: { DSLoadingView(size: 22) },
                            failure: { Image(systemName: "photo").imageScale(.large) }
                        )
                    } else {
                        Text("No image")
                            .font(.subheadline)
                            .foregroundStyle(DSColorToken.textSecondary.color)
                    }
                }
                .padding(12)
            }
            .frame(height: 160)
        }
        .frame(maxWidth: .infinity)
    }

    private func makeTypesRow() -> some View {
        guard let types = viewModel.model?.types, !types.isEmpty else {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 8) {
                Text("Types")
                    .font(.headline)
                    .foregroundStyle(DSColorToken.textPrimary.color)

                FlowLayout(spacing: 8) {
                    ForEach(types, id: \.self) { type in
                        Text(type.displayName)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(type.color.opacity(0.18))
                            .foregroundStyle(type.color)
                            .clipShape(Capsule())
                    }
                }
            }
        )
    }

    private func makeStatsSection() -> some View {
        guard let model = viewModel.model else {
            return AnyView(EmptyView())
        }

        let kinds = PokemonStatKind.allCases

        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                Text("Base stats")
                    .font(.headline)
                    .foregroundStyle(DSColorToken.textPrimary.color)

                VStack(spacing: 10) {
                    ForEach(kinds, id: \.self) { kind in
                        makeStatRow(
                            title: kind.displayName,
                            value: model.statValue(kind) ?? 0
                        )
                    }
                }
                .padding(12)
                .background(DSColorToken.surface.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        )
    }

    private func makeStatRow(title: String, value: Int) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(DSColorToken.textSecondary.color)

                Spacer()

                Text("\(value)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DSColorToken.textPrimary.color)
            }

            GeometryReader { proxy in
                let width = proxy.size.width
                let progress = normalizedStat(value)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DSColorToken.border.color.opacity(0.35))
                        .frame(height: 10)

                    Capsule()
                        .fill(statColor(value))
                        .frame(width: width * progress, height: 10)
                }
            }
            .frame(height: 10)
        }
    }

    private func makeError() -> some View {
        VStack(spacing: 12) {
            Text("Something went wrong")
                .font(.headline)
                .foregroundStyle(DSColorToken.textPrimary.color)

            Button("Retry") {
                Task { await viewModel.load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Stat helpers (simple, “good enough” for showcase)

    private func normalizedStat(_ value: Int) -> CGFloat {
        // Most base stats sit under ~180. Some go above (e.g., 200+), so clamp.
        let maxValue: CGFloat = 200
        return min(max(CGFloat(value) / maxValue, 0), 1)
    }

    private func statColor(_ value: Int) -> Color {
        switch value {
        case ..<60: return .red.opacity(0.85)
        case 60..<100: return .yellow.opacity(0.85)
        default: return .green.opacity(0.85)
        }
    }
}

import SwiftUI

// MARK: - Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .greatestFiniteMagnitude

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: maxWidth == .greatestFiniteMagnitude ? x : maxWidth, height: y + rowHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - View wrapper

struct Flow<FlowContent: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> FlowContent

    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> FlowContent) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        FlowLayout(spacing: spacing) {
            content()
        }
    }
}
