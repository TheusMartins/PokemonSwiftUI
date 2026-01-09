//
//  ImageCaching.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

public protocol ImageCaching: Sendable {
    func image(forKey key: String) async -> Image?
    func insert(_ image: Image?, forKey key: String) async
    func remove(forKey key: String) async
    func removeAll() async
}

