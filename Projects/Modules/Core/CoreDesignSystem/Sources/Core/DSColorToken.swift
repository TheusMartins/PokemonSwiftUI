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
        }
    }
}
