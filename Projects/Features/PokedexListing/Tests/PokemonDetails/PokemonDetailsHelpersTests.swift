//
//  PokemonDetailsHelpersTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 12/01/26.
//

import XCTest
@testable import PokedexListing
import CoreDesignSystem

final class PokemonDetailsHelpersTests: XCTestCase {

    func test_typeColorToken_coversAllCases_andReturnsExpectedToken() {
        // Given
        let expected: [PokemonType: DSColorToken] = [
            .normal: .pokemonTypeNormal,
            .fire: .pokemonTypeFire,
            .water: .pokemonTypeWater,
            .electric: .pokemonTypeElectric,
            .grass: .pokemonTypeGrass,
            .ice: .pokemonTypeIce,
            .fighting: .pokemonTypeFighting,
            .poison: .pokemonTypePoison,
            .ground: .pokemonTypeGround,
            .flying: .pokemonTypeFlying,
            .psychic: .pokemonTypePsychic,
            .bug: .pokemonTypeBug,
            .rock: .pokemonTypeRock,
            .ghost: .pokemonTypeGhost,
            .dragon: .pokemonTypeDragon,
            .dark: .pokemonTypeDark,
            .steel: .pokemonTypeSteel,
            .fairy: .pokemonTypeFairy
        ]

        // When / Then
        PokemonType.allCases.forEach { type in
            let token = PokemonDetailsHelpers.typeColorToken(type)
            XCTAssertEqual(token, expected[type], "Unexpected token for type: \(type.rawValue)")
        }

        // Bonus: garante que você não esqueceu de adicionar no dict
        XCTAssertEqual(expected.count, PokemonType.allCases.count)
    }

    func test_typeSecondaryColorToken_matchesPrimary() {
        // Given / When / Then
        PokemonType.allCases.forEach { type in
            XCTAssertEqual(
                PokemonDetailsHelpers.typeSecondaryColorToken(type),
                PokemonDetailsHelpers.typeColorToken(type)
            )
        }
    }

    func test_normalizedStat_clampsBetween0and1() {
        // Given / When / Then
        XCTAssertEqual(PokemonDetailsHelpers.normalizedStat(-10), 0)
        XCTAssertEqual(PokemonDetailsHelpers.normalizedStat(0), 0)
        XCTAssertEqual(PokemonDetailsHelpers.normalizedStat(100), 0.5)
        XCTAssertEqual(PokemonDetailsHelpers.normalizedStat(200), 1)
        XCTAssertEqual(PokemonDetailsHelpers.normalizedStat(999), 1)
    }

    func test_statBarToken_thresholds() {
        // Given / When / Then
        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(0), .danger)
        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(59), .danger)

        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(60), .pokemonYellow)
        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(99), .pokemonYellow)

        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(100), .pokemonGreen)
        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(144), .pokemonGreen)

        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(145), .pokemonTeal)
        XCTAssertEqual(PokemonDetailsHelpers.statBarToken(200), .pokemonTeal)
    }
}
