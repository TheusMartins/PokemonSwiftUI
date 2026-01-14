//
//  DSFeedbackToast.swift
//  CoreDesignSystem
//
//  Created by Matheus Martins on 13/01/26.
//

import SwiftUI

public struct DSFeedbackToast: View {

    private let title: String
    private let message: String?
    private let style: DSFeedbackStyle
    private let onDismiss: @Sendable () -> Void

    @State private var dragOffsetY: CGFloat = .zero

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

    public var body: some View {
        DSFeedbackView(title: title, message: message, style: style)
            .offset(y: max(dragOffsetY, -60)) // allow pulling up a bit
            .gesture(dragGesture)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                )
            )
            .animation(.snappy, value: dragOffsetY)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { value in
                // only track upward drag (swipe up)
                if value.translation.height < 0 {
                    dragOffsetY = value.translation.height
                } else {
                    dragOffsetY = 0
                }
            }
            .onEnded { value in
                let shouldDismiss = value.translation.height < -40
                if shouldDismiss {
                    onDismiss()
                }
                dragOffsetY = 0
            }
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
