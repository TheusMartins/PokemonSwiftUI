//
//  PokemonItemListView.swift
//  PokedexListing
//
//  Created by Matheus Martins on 10/01/26.
//

import CoreRemoteImage
import CoreDesignSystem
import SwiftUI

struct PokemonListView: View {
    var url: URL
    let pokemonName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.md.value) {
            RemoteImageView(
                url: url,
                placeholder: {
                    EmptyView()
                },
                loading: {
                    DSLoadingView(size: 60)
                },
                failure: {
                    EmptyView()
                }
            )
            
            DSText(pokemonName, style: .title)
        }
    }
}
