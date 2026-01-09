//
//  RemoteImageModel.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

@MainActor
public final class RemoteImageModel: ObservableObject {
    @Published public private(set) var state: RemoteImageState = .idle

    private let loader: ImageLoading
    private var task: Task<Void, Never>?

    public init(loader: ImageLoading) {
        self.loader = loader
    }

    public func load(url: URL?) {
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
                self.state = .failure
            }
        }
    }

    public func cancel() {
        task?.cancel()
        task = nil
    }
}
