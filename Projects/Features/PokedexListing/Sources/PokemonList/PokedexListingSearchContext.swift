//
//  PokedexListingSearchContext.swift
//  PokedexListing
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation
import SwiftUI

// MARK: - Search context

@MainActor
public final class PokedexListingSearchContext: ObservableObject {

    // MARK: - Published state

    @Published public var selectedGenerationId: String?

    // MARK: - Init

    public init(selectedGenerationId: String? = nil) {
        self.selectedGenerationId = selectedGenerationId
    }
}
