//
//  DSProgressView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSProgressView: View {
    public enum Size: Sendable {
        case small, medium, large

        var height: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }
    }

    private let progress: CGFloat
    private let size: Size
    private let trackColor: Color
    private let fillColor: Color

    @State private var displayProgress: CGFloat = 0

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
            .onAppear {
                displayProgress = 0
                withAnimation(.easeOut(duration: 0.7)) {
                    displayProgress = progress
                }
            }
            .onChange(of: progress) { _, newValue in
                withAnimation(.easeOut(duration: 0.35)) {
                    displayProgress = min(max(newValue, 0), 1)
                }
            }
        }
        .frame(height: size.height)
    }
}
