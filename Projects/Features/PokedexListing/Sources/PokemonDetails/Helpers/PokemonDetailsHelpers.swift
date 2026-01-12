//
//  PokemonDetailsHelpers.swift.swift
//  PokedexListing
//
//  Created by Matheus Martins on 12/01/26.
//

import CoreDesignSystem
import Foundation

enum PokemonDetailsHelpers {

    // MARK: - Type -> Design System

    static func typeColorToken(_ type: PokemonType) -> DSColorToken {
        switch type {
        case .normal: return .pokemonTypeNormal
        case .fire: return .pokemonTypeFire
        case .water: return .pokemonTypeWater
        case .electric: return .pokemonTypeElectric
        case .grass: return .pokemonTypeGrass
        case .ice: return .pokemonTypeIce
        case .fighting: return .pokemonTypeFighting
        case .poison: return .pokemonTypePoison
        case .ground: return .pokemonTypeGround
        case .flying: return .pokemonTypeFlying
        case .psychic: return .pokemonTypePsychic
        case .bug: return .pokemonTypeBug
        case .rock: return .pokemonTypeRock
        case .ghost: return .pokemonTypeGhost
        case .dragon: return .pokemonTypeDragon
        case .dark: return .pokemonTypeDark
        case .steel: return .pokemonTypeSteel
        case .fairy: return .pokemonTypeFairy
        }
    }

    static func typeSecondaryColorToken(_ type: PokemonType) -> DSColorToken {
        // hoje é igual, mas deixamos separado p/ evolução futura
        typeColorToken(type)
    }

    // MARK: - Stats

    static func normalizedStat(_ value: Int, maxValue: CGFloat = 200) -> CGFloat {
        min(max(CGFloat(value) / maxValue, 0), 1)
    }

    static func statBarToken(_ value: Int) -> DSColorToken {
        switch value {
        case ..<60:
            return .danger
        case 60..<100:
            return .pokemonYellow
        case 100..<145:
            return .pokemonGreen
        default:
            return .pokemonTeal
        }
    }
}
