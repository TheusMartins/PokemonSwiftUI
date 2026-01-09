//
//  RemoteImageView.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

public struct RemoteImageView: View {

    private let url: URL?
    private let contentMode: ContentMode
    private let showsLoader: Bool

    private let placeholder: AnyView
    private let failure: AnyView

    @StateObject private var model: RemoteImageModel

    public init(
        url: URL?,
        loader: any ImageLoading,
        contentMode: ContentMode = .fill,
        showsLoader: Bool = true,
        placeholder: () -> some View = { Color.clear },
        failure: () -> some View = { Image(systemName: "exclamationmark.triangle").imageScale(.large) }
    ) {
        self.url = url
        self.contentMode = contentMode
        self.showsLoader = showsLoader
        self.placeholder = AnyView(placeholder())
        self.failure = AnyView(failure())
        _model = StateObject(wrappedValue: RemoteImageModel(loader: loader))
    }

    public var body: some View {
        ZStack {
            switch model.state {
            case .idle:
                placeholder

            case .loading:
                placeholder
                if showsLoader {
                    ProgressView()
                }

            case .success(let data):
                RemoteImageDataView(data: data, contentMode: contentMode)

            case .failure:
                failure
            }
        }
        .task(id: url) {
            model.load(url: url)
        }
    }
}

private struct RemoteImageDataView: View {
    let data: Data
    let contentMode: ContentMode

    var body: some View {
        if let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            Image(systemName: "photo")
                .imageScale(.large)
        }
    }
}
