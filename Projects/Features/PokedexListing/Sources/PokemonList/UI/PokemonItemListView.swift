//
//  PokemonItemListView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI
import CoreDesignSystem
import CoreRemoteImage

// MARK: - View

struct PokemonItemListView: View {

    // MARK: - Properties

    let url: URL
    let pokemonName: String

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.large.value) {
            image
            title
        }
    }

    // MARK: - Components

    private var image: some View {
        RemoteImageView(
            url: url,
            placeholder: { Color.clear },
            loading: { DSLoadingView() },
            failure: { Image(systemName: "photo").imageScale(.large) }
        )
        .frame(
            width: DSIconSize.massive.value,
            height: DSIconSize.massive.value
        )
        .clipped()
    }

    private var title: some View {
        DSText(pokemonName, style: .title)
    }
}
