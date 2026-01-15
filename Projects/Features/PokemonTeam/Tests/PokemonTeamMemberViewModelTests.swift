//
//  PokemonTeamMemberViewModelTests.swift
//  PokemonTeamTests
//
//  Created by Matheus Martins on 15/01/26.
//

import XCTest
import CoreDesignSystem
import CorePersistence
@testable import PokemonTeam

@MainActor
final class PokemonTeamMemberViewModelTests: XCTestCase {

    // MARK: - Tests: ViewModel mapping

    func test_init_mapsBasicProperties() {
        // Given
        let spriteURL = URL(string: "https://example.com/25.png")
        let member = TeamPokemon(
            id: 25,
            name: "pikachu",
            spriteURL: spriteURL,
            types: [.electric, .steel],
            stats: []
        )

        // When
        let sut = PokemonTeamMemberViewModel(member: member)

        // Then
        XCTAssertEqual(sut.id, 25)
        XCTAssertEqual(sut.name, "pikachu")
        XCTAssertEqual(sut.spriteURL, spriteURL)
        XCTAssertEqual(sut.types, [.electric, .steel])
        XCTAssertTrue(sut.statsRows.isEmpty)
    }

    func test_init_mapsStatsIntoRows_withExpectedIdsTitlesValuesProgressAndBarToken() {
        // Given
        let stats: [TeamPokemonStat] = [
            .init(kind: .hp, value: 50),          // < 60 => danger
            .init(kind: .attack, value: 60),      // 60..<100 => pokemonYellow
            .init(kind: .defense, value: 100),    // 100..<145 => pokemonGreen
            .init(kind: .speed, value: 145)       // >=145 => pokemonTeal
        ]

        let member = TeamPokemon(
            id: 212,
            name: "scizor",
            spriteURL: URL(string: "https://example.com/212.png"),
            types: [.bug, .steel],
            stats: stats
        )

        // When
        let sut = PokemonTeamMemberViewModel(member: member)

        // Then
        let expectedRows: [DSStatsCardView.Row] = stats.map { stat in
            DSStatsCardView.Row(
                id: stat.kind.rawValue,
                title: stat.kind.rawValue,
                value: stat.value,
                progress: TeamPokemonUIHelpers.normalizedStat(stat.value),
                barToken: TeamPokemonUIHelpers.statBarToken(stat.value)
            )
        }

        XCTAssertEqual(sut.statsRows, expectedRows)

        // Extra explicit assertions (helps debugging when a single field is wrong)
        XCTAssertEqual(sut.statsRows[0].id, TeamPokemonStatKind.hp.rawValue)
        XCTAssertEqual(sut.statsRows[0].title, TeamPokemonStatKind.hp.rawValue)
        XCTAssertEqual(sut.statsRows[0].value, 50)
        XCTAssertEqual(sut.statsRows[0].progress, 0.25, accuracy: 0.0001) // 50/200
        XCTAssertEqual(sut.statsRows[0].barToken, .danger)

        XCTAssertEqual(sut.statsRows[1].value, 60)
        XCTAssertEqual(sut.statsRows[1].barToken, .pokemonYellow)

        XCTAssertEqual(sut.statsRows[2].value, 100)
        XCTAssertEqual(sut.statsRows[2].barToken, .pokemonGreen)

        XCTAssertEqual(sut.statsRows[3].value, 145)
        XCTAssertEqual(sut.statsRows[3].barToken, .pokemonTeal)
    }

    // MARK: - Tests: normalizedStat

    func test_normalizedStat_clampsToZeroToOne_withDefaultMaxValue() {
        // Given
        // When / Then
        XCTAssertEqual(TeamPokemonUIHelpers.normalizedStat(-10), 0, accuracy: 0.0001)
        XCTAssertEqual(TeamPokemonUIHelpers.normalizedStat(0), 0, accuracy: 0.0001)
        XCTAssertEqual(TeamPokemonUIHelpers.normalizedStat(50), 0.25, accuracy: 0.0001)
        XCTAssertEqual(TeamPokemonUIHelpers.normalizedStat(200), 1.0, accuracy: 0.0001)
        XCTAssertEqual(TeamPokemonUIHelpers.normalizedStat(500), 1.0, accuracy: 0.0001)
    }

    func test_normalizedStat_usesCustomMaxValue() {
        // Given
        let maxValue: CGFloat = 400

        // When
        let result = TeamPokemonUIHelpers.normalizedStat(200, maxValue: maxValue)

        // Then
        XCTAssertEqual(result, 0.5, accuracy: 0.0001)
    }

    // MARK: - Tests: statBarToken boundaries

    func test_statBarToken_returnsExpectedToken_forBoundaries() {
        // Given / When / Then
        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(0), .danger)
        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(59), .danger)

        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(60), .pokemonYellow)
        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(99), .pokemonYellow)

        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(100), .pokemonGreen)
        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(144), .pokemonGreen)

        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(145), .pokemonTeal)
        XCTAssertEqual(TeamPokemonUIHelpers.statBarToken(999), .pokemonTeal)
    }

    // MARK: - Tests: type mapping

    func test_typeColorToken_mapsKnownTypes() {
        // Given / When / Then
        XCTAssertEqual(TeamPokemonUIHelpers.typeColorToken(.fire), .pokemonTypeFire)
        XCTAssertEqual(TeamPokemonUIHelpers.typeColorToken(.water), .pokemonTypeWater)
        XCTAssertEqual(TeamPokemonUIHelpers.typeColorToken(.electric), .pokemonTypeElectric)
        XCTAssertEqual(TeamPokemonUIHelpers.typeColorToken(.steel), .pokemonTypeSteel)
        XCTAssertEqual(TeamPokemonUIHelpers.typeColorToken(.fairy), .pokemonTypeFairy)
    }

    func test_typeSecondaryColorToken_isSameAsPrimary_forNow() {
        // Given
        let type: TeamPokemonType = .grass

        // When
        let primary = TeamPokemonUIHelpers.typeColorToken(type)
        let secondary = TeamPokemonUIHelpers.typeSecondaryColorToken(type)

        // Then
        XCTAssertEqual(primary, secondary)
    }
}
