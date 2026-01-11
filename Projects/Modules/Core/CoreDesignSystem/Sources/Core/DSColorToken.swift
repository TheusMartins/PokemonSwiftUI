//
//  DSColorToken.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 10/01/26.
//

import SwiftUI
import UIKit

public enum DSColorToken: Sendable, CaseIterable {
    // Surfaces
    case background
    case surface
    
    // Text
    case textPrimary
    case textSecondary
    
    // Borders
    case border
    
    // Brand (semantic)
    case brandPrimary
    case brandPrimaryOn
    case brandSecondary
    case brandSecondaryOn
    
    // Feedback
    case danger
    
    // Raw theme colors (rarely used directly)
    case pokemonRed
    case pokemonYellow
    case pokemonBlue
    case pokemonGreen
    case pokemonTeal
    
    // Pokemon Types
    case pokemonTypeNormal
    case pokemonTypeFire
    case pokemonTypeWater
    case pokemonTypeElectric
    case pokemonTypeGrass
    case pokemonTypeIce
    case pokemonTypeFighting
    case pokemonTypePoison
    case pokemonTypeGround
    case pokemonTypeFlying
    case pokemonTypePsychic
    case pokemonTypeBug
    case pokemonTypeRock
    case pokemonTypeGhost
    case pokemonTypeDragon
    case pokemonTypeDark
    case pokemonTypeSteel
    case pokemonTypeFairy
}

public extension DSColorToken {
    
    var color: Color {
        Color(uiColor)
    }
    
    var uiColor: UIColor {
        switch self {
            
        // MARK: - Surfaces
            
        case .background:
            return UIColor { traits in
                traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0)
                : UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
            }
            
        case .surface:
            return UIColor { traits in
                traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0)
                : .white
            }
            
        // MARK: - Text
            
        case .textPrimary:
            return UIColor { traits in
                traits.userInterfaceStyle == .dark ? .white : .black
            }
            
        case .textSecondary:
            return UIColor { traits in
                traits.userInterfaceStyle == .dark
                ? UIColor(white: 0.72, alpha: 1.0)
                : UIColor(white: 0.35, alpha: 1.0)
            }
            
        // MARK: - Border
            
        case .border:
            return UIColor { traits in
                traits.userInterfaceStyle == .dark
                ? UIColor(white: 0.22, alpha: 1.0)
                : UIColor(white: 0.88, alpha: 1.0)
            }
            
        // MARK: - Brand (Pokémon themed)
            
        case .brandPrimary:
            return DSColorToken.pokemonRed.uiColor
            
        case .brandPrimaryOn:
            return .white
            
        case .brandSecondary:
            return DSColorToken.pokemonBlue.uiColor
            
        case .brandSecondaryOn:
            return .white
            
            // MARK: - Feedback
            
        case .danger:
            return UIColor(red: 0.93, green: 0.25, blue: 0.25, alpha: 1.0)
            
            // MARK: - Raw Pokémon colors
            
        case .pokemonRed:
            return UIColor(red: 0.93, green: 0.24, blue: 0.22, alpha: 1.0)
            
        case .pokemonYellow:
            return UIColor(red: 0.99, green: 0.82, blue: 0.15, alpha: 1.0)
            
        case .pokemonBlue:
            return UIColor(red: 0.15, green: 0.44, blue: 0.93, alpha: 1.0)
            
        case .pokemonGreen:
            return UIColor(red: 0.20, green: 0.72, blue: 0.34, alpha: 1.0)
            
        case .pokemonTeal:
            return UIColor(red: 0.00, green: 0.73, blue: 0.70, alpha: 1.0)
            
        // MARK: - Pokémon Type Colors
            
        case .pokemonTypeNormal:
            return UIColor(red: 0.66, green: 0.65, blue: 0.48, alpha: 1.0)
            
        case .pokemonTypeFire:
            return UIColor(red: 0.93, green: 0.51, blue: 0.19, alpha: 1.0)
            
        case .pokemonTypeWater:
            return UIColor(red: 0.38, green: 0.56, blue: 0.94, alpha: 1.0)
            
        case .pokemonTypeElectric:
            return UIColor(red: 0.97, green: 0.82, blue: 0.17, alpha: 1.0)
            
        case .pokemonTypeGrass:
            return UIColor(red: 0.48, green: 0.78, blue: 0.30, alpha: 1.0)
            
        case .pokemonTypeIce:
            return UIColor(red: 0.59, green: 0.85, blue: 0.84, alpha: 1.0)
            
        case .pokemonTypeFighting:
            return UIColor(red: 0.76, green: 0.18, blue: 0.16, alpha: 1.0)
            
        case .pokemonTypePoison:
            return UIColor(red: 0.64, green: 0.26, blue: 0.64, alpha: 1.0)
            
        case .pokemonTypeGround:
            return UIColor(red: 0.89, green: 0.75, blue: 0.40, alpha: 1.0)
            
        case .pokemonTypeFlying:
            return UIColor(red: 0.66, green: 0.56, blue: 0.95, alpha: 1.0)
            
        case .pokemonTypePsychic:
            return UIColor(red: 0.98, green: 0.33, blue: 0.53, alpha: 1.0)
            
        case .pokemonTypeBug:
            return UIColor(red: 0.65, green: 0.73, blue: 0.10, alpha: 1.0)
            
        case .pokemonTypeRock:
            return UIColor(red: 0.72, green: 0.63, blue: 0.20, alpha: 1.0)
            
        case .pokemonTypeGhost:
            return UIColor(red: 0.45, green: 0.35, blue: 0.59, alpha: 1.0)
            
        case .pokemonTypeDragon:
            return UIColor(red: 0.44, green: 0.21, blue: 0.99, alpha: 1.0)
            
        case .pokemonTypeDark:
            return UIColor(red: 0.44, green: 0.35, blue: 0.28, alpha: 1.0)
            
        case .pokemonTypeSteel:
            return UIColor(red: 0.72, green: 0.72, blue: 0.81, alpha: 1.0)
            
        case .pokemonTypeFairy:
            return UIColor(red: 0.84, green: 0.52, blue: 0.68, alpha: 1.0)
        }
    }
}
