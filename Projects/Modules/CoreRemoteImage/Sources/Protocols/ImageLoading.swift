//
//  ImageLoading.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation
import SwiftUI

public protocol ImageLoading: Sendable {
    func loadImageData(from url: URL) async throws -> Data
}
