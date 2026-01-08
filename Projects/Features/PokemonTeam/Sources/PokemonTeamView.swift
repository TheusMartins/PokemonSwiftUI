import SwiftUI

public struct PokemonTeamView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("My Team") {
                    Text("Pikachu (#025)")
                    Text("Charizard (#006)")
                    Text("Gengar (#094)")
                }
            }
            .navigationTitle("Team")
        }
    }
}
