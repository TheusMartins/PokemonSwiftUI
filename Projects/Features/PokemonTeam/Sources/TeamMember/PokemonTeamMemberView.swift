//
//  PokemonTeamMemberView.swift
//  PokemonTeam
//
//  Created by Matheus Martins on 12/01/26.
//

import SwiftUI
import CoreDesignSystem
import CorePersistence
import CoreRemoteImage

struct PokemonTeamMemberView: View {

    // MARK: - State / bindings

    @StateObject private var viewModel: PokemonTeamMemberViewModel
    @State private var isShowingDeleteConfirmation: Bool = false

    // MARK: - Dependencies

    private let onDelete: @Sendable (Int) -> Void

    // MARK: - Initialization

    init(
        member: TeamPokemon,
        onDelete: @escaping @Sendable (Int) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: PokemonTeamMemberViewModel(member: member))
        self.onDelete = onDelete
    }

    // MARK: - View

    var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.medium.value) {
            leftColumn
            statsCard
        }
        .padding(DSSpacing.large.value)
        .background(DSColorToken.surface.color)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large.value, style: .continuous))
    }

    // MARK: - Subviews

    private var leftColumn: some View {
        VStack {
            DSText(viewModel.name.capitalized, style: .title, color: .textPrimary)

            typesRow

            pokemonSprite

            deleteButton
        }
    }

    private var typesRow: some View {
        HStack(spacing: DSSpacing.small.value) {
            ForEach(viewModel.types.prefix(2)) { type in
                DSPillView(
                    type.id,
                    size: .small,
                    backgroundToken: TeamPokemonUIHelpers.typeColorToken(type),
                    foregroundToken: .brandPrimaryOn
                )
            }
        }
    }

    private var pokemonSprite: some View {
        RemoteImageView(url: viewModel.spriteURL, contentMode: .fit) {
            EmptyView()
        } loading: {
            DSLoadingView()
        } failure: {
            EmptyView()
        }
        .frame(
            width: DSIconSize.jumbo.value,
            height: DSIconSize.jumbo.value
        )
    }

    private var deleteButton: some View {
        Button {
            isShowingDeleteConfirmation = true
        } label: {
            Image(systemName: "trash")
                .imageScale(.large)
                .foregroundStyle(DSColorToken.textSecondary.color)
                .padding(DSSpacing.small.value)
                .background(DSColorToken.background.color.opacity(0.3))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DSRadius.medium.value,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .alert("Remove Pokémon?", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onDelete(viewModel.id)
            }
        } message: {
            Text("This will remove \(viewModel.name.capitalized) from your team.")
        }
    }

    private var statsCard: some View {
        DSStatsCardView(
            title: "Stats",
            rows: viewModel.statsRows
        )
    }
}

#Preview("PokemonTeamMemberView - Light") {
    PokemonTeamMemberView(
        member: .init(
            id: 212,
            name: "Scizor",
            spriteURL: URL(
                string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/212.png"
            )!,
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
        onDelete: { _ in }
    )
    .padding()
    .background(DSColorToken.background.color)
    .preferredColorScheme(.light)
}

#Preview("PokemonTeamMemberView - Dark") {
    PokemonTeamMemberView(
        member: .init(
            id: 212,
            name: "Scizor",
            spriteURL: URL(
                string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/212.png"
            )!,
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
        onDelete: { _ in }
    )
    .padding()
    .background(DSColorToken.background.color)
    .preferredColorScheme(.dark)
}
