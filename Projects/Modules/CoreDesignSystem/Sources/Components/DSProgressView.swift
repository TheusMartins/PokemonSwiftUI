//
//  DSProgressView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSProgressView: View {

    // MARK: - Nested types

    public enum Size: Sendable {
        case small
        case medium
        case large

        // MARK: - Tokens

        var height: CGFloat {
            switch self {
            case .small: return DSSpacing.small.value
            case .medium: return DSSpacing.medium.value
            case .large: return DSSpacing.large.value
            }
        }
    }

    // MARK: - Private properties

    private let progress: CGFloat
    private let size: Size
    private let trackColor: Color
    private let fillColor: Color

    @State private var displayProgress: CGFloat = .zero

    // MARK: - Initialization

    public init(
        progress: CGFloat,
        size: Size,
        trackColor: Color,
        fillColor: Color
    ) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.trackColor = trackColor
        self.fillColor = fillColor
    }

    // MARK: - View

    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)
                    .frame(height: size.height)

                Capsule()
                    .fill(fillColor)
                    .frame(width: width * displayProgress, height: size.height)
            }
            .onAppear(perform: animateToInitialProgress)
            .onChange(of: progress) { _, newValue in
                animateToProgress(newValue)
            }
        }
        .frame(height: size.height)
    }

    // MARK: - Private methods

    private func animateToInitialProgress() {
        displayProgress = .zero
        withAnimation(.easeOut(duration: 0.7)) {
            displayProgress = progress
        }
    }

    private func animateToProgress(_ value: CGFloat) {
        withAnimation(.easeOut(duration: 0.35)) {
            displayProgress = min(max(value, 0), 1)
        }
    }
}

#Preview("DSProgressView – Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.large.value) {

            DSText("Small", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.15,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.65,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )

                DSProgressView(
                    progress: 1.0,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonBlue.color
                )
            }

            DSText("Medium", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.0,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.45,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )

                DSProgressView(
                    progress: 0.85,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonBlue.color
                )
            }

            DSText("Large", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.25,
                    size: .large,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.75,
                    size: .large,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )
            }
        }
        .padding(DSSpacing.xLarge.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.light)
}

#Preview("DSProgressView – Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.large.value) {

            DSText("Small", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.15,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.65,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )

                DSProgressView(
                    progress: 1.0,
                    size: .small,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonBlue.color
                )
            }

            DSText("Medium", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.0,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.45,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )

                DSProgressView(
                    progress: 0.85,
                    size: .medium,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonBlue.color
                )
            }

            DSText("Large", style: .title, color: .textSecondary)

            VStack(spacing: DSSpacing.small.value) {
                DSProgressView(
                    progress: 0.25,
                    size: .large,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonRed.color
                )

                DSProgressView(
                    progress: 0.75,
                    size: .large,
                    trackColor: DSColorToken.surface.color.opacity(0.6),
                    fillColor: DSColorToken.pokemonYellow.color
                )
            }
        }
        .padding(DSSpacing.xLarge.value)
    }
    .background(DSColorToken.background.color)
    .preferredColorScheme(.dark)
}
