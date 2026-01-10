//
//  PokemonItemListView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import CoreRemoteImage
import CoreDesignSystem
import SwiftUI

struct PokemonItemListView: View {
    var url: URL
    let pokemonName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.md.value) {
            RemoteImageView(
                url: url,
                placeholder: { Color.clear },
                loading: { DSLoadingView(size: 22) },
                failure: { Image(systemName: "photo").imageScale(.large) }
            )
            .frame(width: 80, height: 80)
            .clipped()
            
            DSText(pokemonName, style: .title)
        }
    }
}
