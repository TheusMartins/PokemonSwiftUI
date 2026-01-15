//
//  DSErrorScreenView.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 12/01/26.
//

import SwiftUI

public struct DSErrorScreenView: View {

    // MARK: - Private properties

    private let title: String
    private let buttonTitle: String
    private let onRetry: () -> Void

    // MARK: - Initialization

    public init(
        title: String = "Something went wrong",
        buttonTitle: String = "Retry",
        onRetry: @escaping () -> Void
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.onRetry = onRetry
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: DSSpacing.large.value) {

            Image(.errorImageName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)

            DSText(title, style: .title, color: .textPrimary)
                .multilineTextAlignment(.center)

            Spacer()

            DSButton(
                title: buttonTitle,
                style: .secondary,
                action: onRetry
            )
        }
        .padding(.horizontal, DSSpacing.xLarge.value)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColorToken.background.color)
    }
}

// MARK: - Constants

private extension String {
    static let errorImageName = "suprised_pikachu"
}

// MARK: - Preview

#Preview("Light") {
    DSErrorScreenView(onRetry: {})
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    DSErrorScreenView(onRetry: {})
        .preferredColorScheme(.dark)
}
