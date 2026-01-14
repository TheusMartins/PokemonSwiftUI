//
//  RemoteImageView.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

public struct RemoteImageView<Placeholder: View, Loading: View, Failure: View>: View {

    private let url: URL?
    private let contentMode: ContentMode
    private let placeholder: Placeholder
    private let loading: Loading
    private let failure: Failure

    @StateObject private var model: RemoteImageModel
    private let loader: any ImageLoading

    public init(
        url: URL?,
        loader: any ImageLoading = RemoteImageLoader(),
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder loading: () -> Loading,
        @ViewBuilder failure: () -> Failure
    ) {
        self.url = url
        self.loader = loader
        self.contentMode = contentMode
        self.placeholder = placeholder()
        self.loading = loading()
        self.failure = failure()

        _model = StateObject(wrappedValue: RemoteImageModel(loader: loader))
    }

    public var body: some View {
        ZStack {
            switch model.state {
            case .idle:
                placeholder

            case .loading:
                placeholder
                loading

            case .success(let data):
                RemoteImageDataView(data: data, contentMode: contentMode)

            case .failure:
                failure
            }
        }
        .task(id: url) {
            await model.load(url: url)
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
