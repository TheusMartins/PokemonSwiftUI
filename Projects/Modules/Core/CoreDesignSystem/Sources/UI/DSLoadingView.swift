//
//  DSLoadingView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI

public struct DSLoadingView: View {
    private let size: CGFloat
    private let lineWidth: CGFloat

    public init(
        size: CGFloat = 22,
        lineWidth: CGFloat = 3
    ) {
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Spinner(size: size, lineWidth: lineWidth)
            .accessibilityLabel("Loading")
    }
}

private struct Spinner: View {
    let size: CGFloat
    let lineWidth: CGFloat

    @State private var isAnimating = false

    var body: some View {
        Circle()
            .trim(from: 0.15, to: 0.95)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [
                        DSColorToken.pokemonRed.color,
                        DSColorToken.pokemonYellow.color,
                        DSColorToken.pokemonBlue.color,
                        DSColorToken.pokemonRed.color
                    ]),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 0.9).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}
