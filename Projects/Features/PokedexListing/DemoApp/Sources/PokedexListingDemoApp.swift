import SwiftUI
import PokedexListing

@main
struct PokedexListingDemoApp: App {

    // MARK: - State

    @State private var searchText: String = ""
    @StateObject private var searchContext = PokedexListingSearchContext()

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            PokedexListingRouteView(
                searchText: $searchText,
                usesTabSearch: false,
                searchContext: searchContext
            )
        }
    }
}
