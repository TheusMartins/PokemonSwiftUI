import SwiftUI

public struct PokedexListingView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Text("Bulbasaur (#001)")
                Text("Ivysaur (#002)")
                Text("Venusaur (#003)")
            }
            .navigationTitle("Pokedex")
        }
    }
}
