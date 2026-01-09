//
//  RemoteImageState.swift
//  CoreRemoteImage
//
//  Created by Matheus Martins on 09/01/26.
//

import SwiftUI

public enum RemoteImageState: Equatable {
    case idle
    case loading
    case success(Image)
    case failure
}
