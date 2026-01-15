//
//  ImageLoading.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import SwiftUI

/// Abstraction responsible for asynchronously loading raw image data.
public protocol ImageLoading: Sendable {

    /// Loads image data from the given URL.
    ///
    /// - Parameter url: Remote image URL.
    /// - Returns: Raw image data.
    /// - Throws: An error if the image cannot be loaded.
    func loadImageData(from url: URL) async throws -> Data
}
