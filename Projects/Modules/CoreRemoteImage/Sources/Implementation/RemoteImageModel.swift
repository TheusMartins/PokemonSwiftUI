//
//  RemoteImageModel.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

@MainActor
public final class RemoteImageModel: ObservableObject {

    // MARK: - Published Properties

    @Published public private(set) var state: RemoteImageState = .idle

    // MARK: - Private Properties

    private let loader: ImageLoading
    private var task: Task<Void, Never>?

    // MARK: - Initialization

    public init(loader: ImageLoading = RemoteImageLoader()) {
        self.loader = loader
    }

    // MARK: - Public Methods

    public func load(url: URL?) async {
        task?.cancel()
        state = .idle

        guard let url else { return }

        state = .loading

        task = Task { [weak self] in
            guard let self else { return }

            do {
                let imageData = try await loader.loadImageData(from: url)
                self.state = .success(imageData)
            } catch {
                if Task.isCancelled { return }
                self.state = .failure
            }
        }
    }

    public func cancel() {
        task?.cancel()
        task = nil
    }
}
