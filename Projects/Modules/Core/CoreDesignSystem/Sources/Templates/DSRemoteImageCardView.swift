//
//  DSRemoteImageCardView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 11/01/26.
//

import SwiftUI
import CoreRemoteImage

public struct DSRemoteImageCardView: View {

    private let title: String
    private let url: URL?
    private let height: CGFloat

    public init(
        title: String,
        url: URL?,
        height: CGFloat = 160
    ) {
        self.title = title
        self.url = url
        self.height = height
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.medium.value) {
            DSText(title, style: .body, color: .textSecondary)

            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous)
                    .fill(DSColorToken.surface.color)

                Group {
                    if let url {
                        RemoteImageView(
                            url: url,
                            placeholder: { Color.clear },
                            loading: { DSLoadingView() },
                            failure: { Image(systemName: "photo").imageScale(.large) }
                        )
                        .padding(DSSpacing.large.value)
                    } else {
                        DSText("No image", style: .body, color: .textSecondary)
                    }
                }
            }
            .frame(height: height)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("DSRemoteImageCardView – Light") {
    ZStack {
        DSColorToken.background.color.ignoresSafeArea()

        DSRemoteImageCardView(
            title: "Default",
            url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")
        )
        .padding(DSSpacing.xLarge.value)
    }
    .preferredColorScheme(.light)
}

#Preview("DSRemoteImageCardView – Dark") {
    ZStack {
        DSColorToken.background.color.ignoresSafeArea()

        DSRemoteImageCardView(
            title: "Shiny",
            url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/4.png")
        )
        .padding(DSSpacing.xLarge.value)
    }
    .preferredColorScheme(.dark)
}
