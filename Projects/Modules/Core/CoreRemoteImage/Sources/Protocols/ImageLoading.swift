//
//  ImageLoading.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import SwiftUI

public protocol ImageLoading: Sendable {
    func loadImage(from url: URL) async throws -> Image
}
