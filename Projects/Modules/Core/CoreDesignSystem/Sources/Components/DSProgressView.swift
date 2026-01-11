//
//  DSProgressView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI

public struct DSProgressView: View {
    public enum Size: Sendable {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 10
            case .large: return 14
            }
        }

        var cornerRadius: CGFloat {
            height / 2
        }
    }

    private let progress: CGFloat
    private let size: Size
    private let trackColor: Color
    private let fillColor: Color

    public init(
        progress: CGFloat,
        size: Size = .medium,
        trackColor: Color = DSColorToken.border.color.opacity(0.35),
        fillColor: Color
    ) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.trackColor = trackColor
        self.fillColor = fillColor
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)

                Capsule()
                    .fill(fillColor)
                    .frame(width: geo.size.width * progress)
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        .frame(height: size.height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

// MARK: - DS convenience

public extension DSProgressView {
    init(
        progress: CGFloat,
        size: Size = .medium,
        trackToken: DSColorToken = .border,
        fillToken: DSColorToken
    ) {
        self.init(
            progress: progress,
            size: size,
            trackColor: trackToken.color.opacity(0.35),
            fillColor: fillToken.color
        )
    }
}
