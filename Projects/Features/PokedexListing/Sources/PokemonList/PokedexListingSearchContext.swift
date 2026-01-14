//
//  PokedexListingSearchContext.swift
//  PokedexListing
//
//  Created by Matheus Martins on 14/01/26.
//

import Foundation
import SwiftUI

@MainActor
public final class PokedexListingSearchContext: ObservableObject {
    @Published public var selectedGenerationId: String?
    
    public init(selectedGenerationId: String? = nil) {
        self.selectedGenerationId = selectedGenerationId
    }
}
