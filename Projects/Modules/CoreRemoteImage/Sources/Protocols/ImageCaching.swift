//
//  ImageCaching.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import Foundation

public protocol ImageCaching: Sendable {
    func data(forKey key: String) async -> Data?
    func insert(_ data: Data?, forKey key: String) async
    func remove(forKey key: String) async
    func removeAll() async
}
