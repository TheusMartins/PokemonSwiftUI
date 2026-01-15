//
//  DSFeedbackToast.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI

public struct DSFeedbackToast: View {

    // MARK: - Private properties

    private let title: String
    private let message: String?
    private let style: DSFeedbackStyle
    private let onDismiss: @Sendable () -> Void

    @State private var dragOffsetY: CGFloat = .zero

    // MARK: - Initialization

    public init(
        title: String,
        message: String? = nil,
        style: DSFeedbackStyle = .info,
        onDismiss: @escaping @Sendable () -> Void
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.onDismiss = onDismiss
    }

    // MARK: - View

    public var body: some View {
        DSFeedbackView(title: title, message: message, style: style)
            .offset(y: max(dragOffsetY, Constants.maxUpwardOffset))
            .gesture(dragGesture)
            .transition(toastTransition)
            .animation(.snappy, value: dragOffsetY)
    }

    // MARK: - Private computed properties

    private var toastTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: Constants.minimumDragDistance, coordinateSpace: .local)
            .onChanged { value in
                if value.translation.height < .zero {
                    dragOffsetY = value.translation.height
                } else {
                    dragOffsetY = .zero
                }
            }
            .onEnded { value in
                if value.translation.height < Constants.dismissThreshold {
                    onDismiss()
                }
                dragOffsetY = .zero
            }
    }
}

// MARK: - Constants

private extension DSFeedbackToast {
    enum Constants {
        static let minimumDragDistance: CGFloat = 8
        static let dismissThreshold: CGFloat = -40
        static let maxUpwardOffset: CGFloat = -60
    }
}

// MARK: - Preview

private struct DSFeedbackToastPreviewScreen: View {

    @State private var isPresented = true

    var body: some View {
        ZStack(alignment: .top) {
            DSColorToken.background.color.ignoresSafeArea()

            VStack(spacing: DSSpacing.large.value) {
                Spacer()

                DSButton(title: isPresented ? "Hide" : "Show") {
                    withAnimation(.snappy) { isPresented.toggle() }
                }
            }
            .padding()

            if isPresented {
                DSFeedbackToast(
                    title: "Pokémon added",
                    message: "Scizor was added to your team.",
                    style: .success,
                    onDismiss: { withAnimation(.snappy) { isPresented = false } }
                )
                .padding(.horizontal, DSSpacing.xLarge.value)
                .padding(.top, DSSpacing.large.value)
            }
        }
    }
}

#Preview("DSFeedbackToast - Light") {
    DSFeedbackToastPreviewScreen()
        .preferredColorScheme(.light)
}

#Preview("DSFeedbackToast - Dark") {
    DSFeedbackToastPreviewScreen()
        .preferredColorScheme(.dark)
}
