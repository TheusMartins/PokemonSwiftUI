//
//  DSLoadingView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSLoadingView: View {

    // MARK: - Private properties

    private let size: CGFloat
    private let lineWidth: CGFloat

    // MARK: - Initialization

    public init(
        size: CGFloat = DSIconSize.medium.value,
        lineWidth: CGFloat = 3
    ) {
        self.size = size
        self.lineWidth = lineWidth
    }

    // MARK: - View

    public var body: some View {
        Spinner(size: size, lineWidth: lineWidth)
            .accessibilityLabel(Strings.loadingAccessibilityLabel)
    }
}

// MARK: - Supporting views

private struct Spinner: View {

    // MARK: - Private properties

    private let size: CGFloat
    private let lineWidth: CGFloat

    @State private var isAnimating = false

    // MARK: - Initialization

    init(size: CGFloat, lineWidth: CGFloat) {
        self.size = size
        self.lineWidth = lineWidth
    }

    // MARK: - View

    var body: some View {
        Circle()
            .trim(from: Constants.trimStart, to: Constants.trimEnd)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: gradientColors),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? Constants.rotationDegrees : 0))
            .animation(
                .linear(duration: Constants.animationDuration)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }

    // MARK: - Tokens

    private var gradientColors: [Color] {
        [
            DSColorToken.pokemonRed.color,
            DSColorToken.pokemonYellow.color,
            DSColorToken.pokemonBlue.color,
            DSColorToken.pokemonRed.color
        ]
    }
}

// MARK: - Constants

private extension Spinner {
    enum Constants {
        static let trimStart: CGFloat = 0.15
        static let trimEnd: CGFloat = 0.95
        static let rotationDegrees: Double = 360
        static let animationDuration: Double = 0.9
    }
}

private extension DSLoadingView {
    enum Strings {
        static let loadingAccessibilityLabel = "Loading"
    }
}

// MARK: - Preview

#Preview("Light") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        DSLoadingView(size: DSIconSize.huge.value)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ZStack {
        DSColorToken.background.color
            .ignoresSafeArea()

        DSLoadingView(size: DSIconSize.huge.value)
    }
    .preferredColorScheme(.dark)
}
