import SwiftUI
import CoreDesignSystem
import CorePersistence

struct PokemonTeamView: View {

    @StateObject private var viewModel: PokemonTeamViewModel

    init(viewModel: PokemonTeamViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                DSLoadingView(size: DSIconSize.huge.value)

            case .loaded:
                content

            case .failed:
                DSErrorScreenView {
                    Task { await viewModel.load() }
                }
            }
        }
        .background(DSColorToken.background.color)
        .navigationTitle("My Team")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: DSSpacing.large.value) {
                if viewModel.members.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.members, id: \.id) { member in
                        PokemonTeamMemberView(
                            member: member,
                            onDelete: { id in
                                Task { await viewModel.delete(memberId: id) }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, DSSpacing.xLarge.value)
            .padding(.top, DSSpacing.large.value)
            .padding(.bottom, DSSpacing.huge.value)
        }
    }

    private var emptyState: some View {
        VStack(spacing: DSSpacing.medium.value) {
            DSText("Your team is empty", style: .title, color: .textPrimary)
            DSText("Add Pokémon from the listing to see them here.", style: .body, color: .textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, DSSpacing.huge.value)
    }
}

#Preview("PokemonTeamView - Light") {
    NavigationStack {
        PokemonTeamView(
            viewModel: PokemonTeamViewModel(
                store: PreviewPokemonTeamStore()
            )
        )
    }
    .preferredColorScheme(.light)
}

#Preview("PokemonTeamView - Dark") {
    NavigationStack {
        PokemonTeamView(
            viewModel: PokemonTeamViewModel(
                store: PreviewPokemonTeamStore()
            )
        )
    }
    .preferredColorScheme(.dark)
}

// MARK: - Preview Store

final class PreviewPokemonTeamStore: PokemonTeamStoring {

    func fetchTeam() async throws -> [TeamPokemon] {
        [
            .init(
                id: 212,
                name: "Scizor",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/212.png")!,
                types: [.bug, .steel],
                stats: [
                    .init(kind: .hp, value: 70),
                    .init(kind: .attack, value: 130),
                    .init(kind: .defense, value: 100),
                    .init(kind: .specialAttack, value: 55),
                    .init(kind: .specialDefense, value: 80),
                    .init(kind: .speed, value: 65)
                ]
            ),

            .init(
                id: 6,
                name: "Charizard",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png")!,
                types: [.fire, .flying],
                stats: [
                    .init(kind: .hp, value: 78),
                    .init(kind: .attack, value: 84),
                    .init(kind: .defense, value: 78),
                    .init(kind: .specialAttack, value: 109),
                    .init(kind: .specialDefense, value: 85),
                    .init(kind: .speed, value: 100)
                ]
            ),

            .init(
                id: 9,
                name: "Blastoise",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/9.png")!,
                types: [.water],
                stats: [
                    .init(kind: .hp, value: 79),
                    .init(kind: .attack, value: 83),
                    .init(kind: .defense, value: 100),
                    .init(kind: .specialAttack, value: 85),
                    .init(kind: .specialDefense, value: 105),
                    .init(kind: .speed, value: 78)
                ]
            ),

            .init(
                id: 25,
                name: "Pikachu",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")!,
                types: [.electric],
                stats: [
                    .init(kind: .hp, value: 35),
                    .init(kind: .attack, value: 55),
                    .init(kind: .defense, value: 40),
                    .init(kind: .specialAttack, value: 50),
                    .init(kind: .specialDefense, value: 50),
                    .init(kind: .speed, value: 90)
                ]
            ),

            .init(
                id: 143,
                name: "Snorlax",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png")!,
                types: [.normal],
                stats: [
                    .init(kind: .hp, value: 160),
                    .init(kind: .attack, value: 110),
                    .init(kind: .defense, value: 65),
                    .init(kind: .specialAttack, value: 65),
                    .init(kind: .specialDefense, value: 110),
                    .init(kind: .speed, value: 30)
                ]
            ),

            .init(
                id: 448,
                name: "Lucario",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/448.png")!,
                types: [.fighting, .steel],
                stats: [
                    .init(kind: .hp, value: 70),
                    .init(kind: .attack, value: 110),
                    .init(kind: .defense, value: 70),
                    .init(kind: .specialAttack, value: 115),
                    .init(kind: .specialDefense, value: 70),
                    .init(kind: .speed, value: 90)
                ]
            )
        ]
    }

    func delete(memberId: Int) async throws { }
}
